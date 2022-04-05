import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mars_flights/out.dart';
import 'package:provider/provider.dart';

/// Convenience function to get the [FetchNotifier] '[Provider]'.
FetchNotifier getFetchNotifier(BuildContext context, {required bool listen}) =>
    Provider.of<FetchNotifier>(context, listen: listen);

/// Fetches everything that's used from the api (with http)
/// The [HttpClient] is closed when everything has been fetched.
/// First 'flight' (the next available launch),
/// then 'flights' (the upcoming launches).
/// This is all done in the [fetchAll]() function.
class FetchNotifier extends ChangeNotifier {
  bool fetchAllHasBeenCalled = false;

  late Flight flight;
  bool hasFlight = false;

  final flights = <Flight>[];
  bool hasFlights = false;

  String flightErrorMessage = 'Fetching flight info...';
  String allFlightsErrorMessage = '';

  /// The main starting point for the app data.
  /// Called only once.
  Future<void> fetchAll(BuildContext context, http.Client client) async {
    fetchAllHasBeenCalled = true;

    final fetcher = Fetcher(client);
    try {
      final flight_ = await fetcher.getFlight();

      flight = Flight.fromJson(flight_);

      hasFlight = true;
    } catch (error) {
      flightErrorMessage = _formatError(error);

      // Allow app to try again later.
      fetchAllHasBeenCalled = false;
    }

    notifyListeners();

    try {
      final allFlights_ = await fetcher.getFlights();

      for (final flight in allFlights_) {
        try {
          flights.add(Flight.fromJson(flight));
        } catch (error) {
          logError('Ignoring bad flight');
        }
      }
      hasFlights = true;
    } catch (error) {
      allFlightsErrorMessage = _formatError(error);

      // Allow app to try again later.
      fetchAllHasBeenCalled = false;
    }

    notifyListeners();
    client.close();
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

/// Helper class to fetch and convert json
/// In this API, both JSON lists and JSON objects (maps) are returned, so
/// [List]s of [Map] are fetched with [_getList]
/// and a [Map] are fetched with [_getMap]
/// The [Fetcher] class and [getFlight](), [getFlights]()
/// are only public for the tests.
class Fetcher {
  final http.Client client;

  Fetcher(this.client);

  Future<Map<String, dynamic>> getFlight() async => _getMap('next');

  Future<List<dynamic>> getFlights() async => _getList('upcoming');

  Future<Map<String, dynamic>> _getMap(String url) async {
    final json = await _getJson(url);

    return jsonDecode(json);
  }

  Future<List<dynamic>> _getList(String url) async {
    final json = await _getJson(url);

    return jsonDecode(json);
  }

  /// url = the last bit of the endpoint
  /// i.e. 'upcoming' or 'next'
  Future<String> _getJson(String url) async {
    final response = await client.get(
      Uri.parse('https://api.spacexdata.com/v4/launches/$url'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      final n = response.statusCode;
      var message = 'Failed to fetch $url from the API.\n($n';

      if (_friendlyHttpStatus.containsKey(n)) {
        message += ' -  ${_friendlyHttpStatus[n]!}.)';
      } else {
        message += ')';
        logError('Unknown http status code $n');
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

/// TODO doc
class Flight {
  Flight.fromJson(Map<String, dynamic> json)
      : details = _getFieldOrNull('details', json),
        crew = _getFieldOrNull('crew', json)
            .map<String>((member) => member.toString())
            .toList(),
        launchLibraryId = _getFieldOrNull('launch_library_id', json).toString();

  // final _Links _links;
  final String? details;

  final List<String>? crew;
  final String? launchLibraryId;
// final _Reddit _reddit;
}

// class _Reddit {
//   _Reddit(this.campaign, this.launch);
//
//   final String campaign;
//   final String launch;
// TODO media, recovery
// }
