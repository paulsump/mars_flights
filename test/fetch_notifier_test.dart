import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mars_flights/fetch_notifier.dart';

/// Generate a MockClient using the Mockito package.
/// Create new instances of this class in each test.
void main() {
  String fixture(String name) => File('test_data/$name').readAsStringSync();

  group('fetcher.getNextLaunch()', () {
    test('returns a Map if the http call completes successfully', () async {
      final client = MockClient((_) async => http.Response(
              fixture('nextLaunch1.json'), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));

      final fetcher = Fetcher(client);
      final nextLaunch = await fetcher.getNextLaunch();

      expect(Launch.fromJson(nextLaunch), isA<Launch>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient((_) async => http.Response('Not Found', 404));

      final fetcher = Fetcher(client);
      expect(fetcher.getNextLaunch(), throwsException);
    });
  });

  group('fetcher.getUpcomingLaunches()', () {
    test('returns a List if the http call completes successfully', () async {
      final client = MockClient((_) async => http.Response(
              fixture('upcoming_launches.json'), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));

      final fetcher = Fetcher(client);
      final upcomingLaunches_ = await fetcher.getUpcomingLaunches();

      expect(
          upcomingLaunches_
              .map((upcomingLaunch) => Launch.fromJson(upcomingLaunch))
              .toList(),
          isA<List<Launch>>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient((_) async => http.Response('Not Found', 404));

      final fetcher = Fetcher(client);
      expect(fetcher.getUpcomingLaunches(), throwsException);
    });
  });
}
