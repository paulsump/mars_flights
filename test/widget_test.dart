// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mars_flights/main.dart';
import 'package:mars_flights/view/countdown_page.dart';

Future<http.Response> _getGoodResponse(
    http.Request url, String fileName) async {
  String fixture(String name) => File('test_data/$name').readAsStringSync();

  const base = 'GET https://api.spacexdata.com/v4/';

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
  };

  switch (url.toString()) {
    case base + 'launches/next':
      return http.Response(fixture(fileName), 200, headers: headers);
    case base + 'launches/upcoming':
      return http.Response(fixture('upcoming_launches.json'), 200,
          headers: headers);
    case base + 'launchpads':
      return http.Response(fixture('launch_pads.json'), 200, headers: headers);
  }
  throw 'huh? ($url)';
}

Future<http.Response> _getGoodResponse1(http.Request url) async =>
    _getGoodResponse(url, 'nextLaunch1.json');

Future<http.Response> _getGoodResponse2(http.Request url) async =>
    _getGoodResponse(url, 'nextLaunch2.json');

Future<http.Response> _getEmptyResponse(http.Request url) async {
  const base = 'GET https://api.spacexdata.com/v4/';

  switch (url.toString()) {
    case base + 'launches/next':
      return http.Response('{}', 200);
    case base + 'launches/upcoming':
      return http.Response('[]', 200);
    case base + 'launchpads':
      return http.Response('[]', 200);
  }
  throw 'empty huh? ($url)';
}

void main() {
  _test(app, tester) async {
    await tester.pumpWidget(app);

    expect(find.byType(CountdownPage), findsOneWidget);
    expect(find.textContaining('SECONDS'), findsNothing);

    await tester.pump();
    expect(find.textContaining('SECONDS'), findsOneWidget);
  }

  testWidgets('With file 1, Countdown page', (WidgetTester tester) async {
    _test(createApp(client: MockClient(_getGoodResponse1)), tester);
  });

  testWidgets('With file 2, Countdown page', (WidgetTester tester) async {
    _test(createApp(client: MockClient(_getGoodResponse2)), tester);
  });

  testWidgets('Countdown page - Empty map', (WidgetTester tester) async {
    await tester.pumpWidget(createApp(client: MockClient(_getEmptyResponse)));

    expect(find.byType(CountdownPage), findsOneWidget);
    expect(find.textContaining('problem'), findsNothing);
  });
}
