// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mars_flights/main.dart';
import 'package:mars_flights/view/countdown_page.dart';

Future<http.Response> _getGoodResponse(http.Request url) async {
  String fixture(String name) => File('test_data/$name').readAsStringSync();

  const base = 'GET https://api.spacexdata.com/v4/launches/';

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
  };

  switch (url.toString()) {
    case base + 'next':
      return http.Response(fixture('flight.json'), 200, headers: headers);
    case base + 'upcoming':
      return http.Response(fixture('flights.json'), 200, headers: headers);
  }
  throw 'huh?';
}

Future<http.Response> _getEmptyResponse(http.Request url) async {
  const base = 'GET https://api.spacexdata.com/v4/launches/';

  switch (url.toString()) {
    case base + 'next':
      return http.Response('{}', 200);
    case base + 'upcoming':
      return http.Response('[]', 200);
  }
  throw 'huh?';
}

void main() {
  final goodApp = createApp(client: MockClient(_getGoodResponse));
  final emptyApp = createApp(client: MockClient(_getEmptyResponse));

  testWidgets('Countdown page', (WidgetTester tester) async {
    await tester.pumpWidget(goodApp);

    expect(find.byType(CountdownPage), findsOneWidget);
    expect(find.textContaining('SECONDS'), findsNothing);

    await tester.pump();
    expect(find.textContaining('SECONDS'), findsOneWidget);
  });

  // testWidgets('Countdown page - Empty map', (WidgetTester tester) async {
  //   await tester.pumpWidget(emptyApp);
  //
  //   expect(find.byType(CountdownPage), findsOneWidget);
  //   expect(find.textContaining('problem'), findsNothing);
  // });
}
