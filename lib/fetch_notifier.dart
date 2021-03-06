import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mars_flights/out.dart';
import 'package:provider/provider.dart';

/// Convenience function to get the [FetchNotifier] '[Provider]'.
FetchNotifier getFetchNotifier(BuildContext context, {required bool listen}) =>
    Provider.of<FetchNotifier>(context, listen: listen);

/// Fetch all the info from the spaceX API
void fetchAll(BuildContext context) {
  final fetchNotifier = getFetchNotifier(context, listen: false);

  if (!fetchNotifier.fetchAllHasBeenCalled) {
    unawaited(fetchNotifier.fetchAll(context));
  }
}

/// Fetches everything that's used from the api (with http)
/// The [HttpClient] is closed when everything has been fetched.
/// First 'nextLaunch' (the next available launch),
/// then 'upcomingLaunches'.
/// This is all done in the [fetchAll]() function.
class FetchNotifier extends ChangeNotifier {
  FetchNotifier({required http.Client client}) : _client = client;

  final http.Client _client;
  bool fetchAllHasBeenCalled = false;

  late Launch nextLaunch;
  bool hasNextLaunch = false;
  String nextLaunchErrorMessage = 'Fetching next launch info...';

  // TODO Dry / Extract this repeated pattern...

  final upcomingLaunches = <Launch>[];
  bool hasUpcomingLaunches = false;
  String upcomingLaunchesErrorMessage = '';

  final launchPads = <LaunchPad>[];
  bool hasLaunchPads = false;
  String launchPadsErrorMessage = '';

  final formattedUpcomingLaunches = <FormattedUpcomingLaunch>[];

  String nextLaunchMessage = '';

  bool get hasNextLaunchMessage => hasNextLaunch && hasLaunchPads;

  /// The main starting point for the app data.
  /// Called only once.
  Future<void> fetchAll(BuildContext context) async {
    fetchAllHasBeenCalled = true;

    final fetcher = Fetcher(_client);
    try {
      final nextLaunch_ = await fetcher.getNextLaunch();

      nextLaunch = Launch.fromJson(nextLaunch_);

      hasNextLaunch = true;
    } catch (error) {
      nextLaunchErrorMessage = _formatError(error);

      // Allow app to try again later.
      fetchAllHasBeenCalled = false;
    }

    notifyListeners();

    try {
      final upcomingLaunches_ = await fetcher.getUpcomingLaunches();

      for (final upcomingLaunch in upcomingLaunches_) {
        try {
          upcomingLaunches.add(Launch.fromJson(upcomingLaunch));
        } catch (error) {
          logError('Ignoring bad next launch info.');
        }
      }
      hasUpcomingLaunches = true;
    } catch (error) {
      upcomingLaunchesErrorMessage = _formatError(error);

      // Allow app to try again later.
      fetchAllHasBeenCalled = false;
    }

    notifyListeners();

    try {
      final launchPads_ = await fetcher.getLaunchPads();

      for (final launchPad in launchPads_) {
        try {
          launchPads.add(LaunchPad.fromJson(launchPad));
        } catch (error) {
          logError('Ignoring bad launchPad');
        }
      }
      hasLaunchPads = true;
    } catch (error) {
      launchPadsErrorMessage = _formatError(error);

      // Allow app to try again later.
      fetchAllHasBeenCalled = false;
    }

    notifyListeners();

    if (hasNextLaunch && nextLaunch.isValid) {
      final formattedUpcomingLaunch =
          FormattedUpcomingLaunch.fromLaunch(nextLaunch, launchPads);

      nextLaunchMessage =
          "Hi!\n\nHere's the details of the next SpaceX launch...\n\nMission: ${formattedUpcomingLaunch.name}.\nLaunch Pad: ${formattedUpcomingLaunch.pad}.\nDate: ${formattedUpcomingLaunch.date}.\n\nShall I book it?!";

      notifyListeners();
    }

    if (hasUpcomingLaunches) {
      for (final upcomingLaunch in upcomingLaunches) {
        if (upcomingLaunch.isValid) {
          formattedUpcomingLaunches.add(
              FormattedUpcomingLaunch.fromLaunch(upcomingLaunch, launchPads));
        }
      }

      notifyListeners();
    }

    if (fetchAllHasBeenCalled) {
      _client.close();
    }
  }

  String _formatError(Object error) {
    var message = error.toString();

    if (message.startsWith('Exception: ')) {
      message = message.replaceFirst('Exception: ', '');
    }

    out(message);
    return message;
  }
}

String _findPadName(String id, List<LaunchPad> launchPads) {
  for (final launchPad in launchPads) {
    if (launchPad.id == id) {
      return launchPad.name;
    }
  }

  logError("Failed to find launch pad '$id'");
  return '';
}

/// Make the data easier for the ui to use.
class FormattedUpcomingLaunch {
  FormattedUpcomingLaunch.fromLaunch(Launch launch, List<LaunchPad> launchPads)
      : id = launch.id!,
        name = launch.name!,
        date = _formatDate(launch.date!, launch.datePrecision!),
        pad = _findPadName(launch.launchPad!, launchPads);

  final String id, name, date, pad;
}

/// Create a string for the ui based on how accurate the date is.
String _formatDate(DateTime date, String precision) {
  switch (precision) {
    case 'hour':
      return DateFormat("h a MMM d")
          .format(date)
          .replaceFirst('AM', 'am')
          .replaceFirst('PM', 'pm');
    case 'day':
      return DateFormat('MMMM d').format(date);
    case 'month':
      return DateFormat('MMMM').format(date);
    case 'quarter':
      return DateFormat('QQQ').format(date);
  }

  logError('Unhandled date precision: $precision');
  return DateFormat('dd MMMM hh:mm').format(date);
}

/// Helper class to fetch and convert json
/// In this API, both JSON lists and JSON objects (maps) are returned, so
/// [List]s of [Map] are fetched with [_getList]
/// and a [Map] are fetched with [_getMap]
/// The [Fetcher] class and [getNextLaunch](), [getUpcomingLaunches]()
/// are only public for the tests.
class Fetcher {
  final http.Client client;

  Fetcher(this.client);

  Future<Map<String, dynamic>> getNextLaunch() async =>
      _getMap('launches/next');

  Future<List<dynamic>> getUpcomingLaunches() async =>
      _getList('launches/upcoming');

  //TODO add test for this using test_data/launch_pads.json
  Future<List<dynamic>> getLaunchPads() async => _getList('launchpads');

  Future<Map<String, dynamic>> _getMap(String url) async {
    final json = await _getJson(url);
    return jsonDecode(json);
  }

  Future<List<dynamic>> _getList(String url) async =>
      jsonDecode(await _getJson(url));

  /// Check internet, return [Response]
  Future<http.Response> _getResponse(String url) async {
    try {
      return await client.get(
        Uri.parse('https://api.spacexdata.com/v4/$url'),
      );
    } on SocketException catch (e) {
      logError(e.message);

      throw Exception('There was a problem fetching the data from the web.');
    }
  }

  /// url = the last bit of the endpoint
  /// i.e. 'upcoming' or 'next'
  Future<String> _getJson(String url) async {
    final http.Response response = await _getResponse(url);

    final code = response.statusCode;

    if (code == 200) {
      return response.body;
    } else {
      var message = 'Failed to fetch $url from the API.\n($code';

      if (_friendlyHttpStatus.containsKey(code)) {
        message += ' -  ${_friendlyHttpStatus[code]!}.)';
      } else {
        message += ')';

        logError('Unknown http status code $code');
      }
      throw Exception(message);
    }
  }
}

/// [Map] for converting HTTP status codes to user 'friendly' messages.
const _friendlyHttpStatus = {
  200: 'OK',
  201: 'Created',
  202: 'Accepted',
  203: 'Non-Authoritative Information',
  204: 'No Content',
  205: 'Reset Content',
  206: 'Partial Content',
  300: 'Multiple Choices',
  301: 'Moved Permanently',
  302: 'Found',
  303: 'See Other',
  304: 'Not Modified',
  305: 'Use Proxy',
  306: 'Unused',
  307: 'Temporary Redirect',
  400: 'Bad Request',
  401: 'Unauthorized',
  402: 'Payment Required',
  403: 'Forbidden',
  404: 'Not Found',
  405: 'Method Not Allowed',
  406: 'Not Acceptable',
  407: 'Proxy Authentication Required',
  408: 'Request Timeout',
  409: 'Conflict',
  410: 'Gone',
  411: 'Length Required',
  412: 'Precondition Required',
  413: 'Request Entry Too Large',
  414: 'Request-URI Too Long',
  415: 'Unsupported Media Type',
  416: 'Requested Range Not Satisfiable',
  417: 'Expectation Failed',
  418: 'I\'m a teapot',
  429: 'Too Many Requests',
  500: 'Internal Server Error',
  501: 'Not Implemented',
  502: 'Bad Gateway',
  503: 'Service Unavailable',
  504: 'Gateway Timeout',
  505: 'HTTP Version Not Supported',
};

dynamic _getFieldOrNull(String key, Map<String, dynamic> json) =>
    json.containsKey(key) ? json[key] : null;

/// All the info needed about a launch
/// whether it's the next launch or the upcoming launches
class Launch {
  Launch.fromJson(Map<String, dynamic> json)
      : details = _getFieldOrNull('details', json),
        dateUnix = _getFieldOrNull('date_unix', json),
        datePrecision = _getFieldOrNull('date_precision', json),
        launchPad = _getFieldOrNull('launchpad', json),
        name = _getFieldOrNull('name', json),
        id = _getFieldOrNull('id', json);

  final String? id;
  final String? launchPad;

  final String? name;
  final String? details;

  final int? dateUnix;
  final String? datePrecision;

  /// launch date and time
  DateTime? get date => dateUnix == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(dateUnix! * 1000);

  /// check if the fields are all valid (loaded correctly).
  bool get isValid =>
      id != null &&
          name != null &&
          dateUnix != null &&
          datePrecision != null &&
          launchPad != null;
}

/// Access to the launch pad's name via it's id
class LaunchPad {
  LaunchPad.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'];

  final String name;
  final String id;
}
