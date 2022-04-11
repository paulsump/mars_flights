import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mars_flights/fetch_notifier.dart';

/// Generate a MockClient using the Mockito package.
/// Create new instances of this class in each test.
void main() {
  String fixture(String name) => File('test_data/$name').readAsStringSync();

  group('fetcher.getFlight()', () {
    test('returns a Map if the http call completes successfully', () async {
      final client = MockClient((_) async => http.Response(
              fixture('flight.json'), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));

      final fetcher = Fetcher(client);
      final flight = await fetcher.getFlight();

      expect(Flight.fromJson(flight), isA<Flight>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient((_) async => http.Response('Not Found', 404));

      final fetcher = Fetcher(client);
      expect(fetcher.getFlight(), throwsException);
    });
  });

  group('fetcher.getFlights()', () {
    test('returns a List if the http call completes successfully', () async {
      final client = MockClient((_) async => http.Response(
              fixture('upcoming_launches.json'), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));

      final fetcher = Fetcher(client);
      final flights_ = await fetcher.getFlights();

      expect(flights_.map((flight) => Flight.fromJson(flight)).toList(),
          isA<List<Flight>>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient((_) async => http.Response('Not Found', 404));

      final fetcher = Fetcher(client);
      expect(fetcher.getFlights(), throwsException);
    });
  });
}
