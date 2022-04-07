import 'package:flutter/material.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:provider/provider.dart';

/// Convenience function to get the [FavoritesNotifier] '[Provider]'.
FavoritesNotifier getFavoritesNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<FavoritesNotifier>(context, listen: listen);

/// Access to the list of favorite flights.
class FavoritesNotifier extends ChangeNotifier {
  final _flightNames = <String>[];

  void toggle(String flightName) {
    if (_flightNames.contains(flightName)) {
      _flightNames.remove(flightName);
    } else {
      _flightNames.add(flightName);
    }

    notifyListeners();
    //TODO LOCAL STORAGE FOR NEXT RUN
  }

  bool contains(String flightName) => _flightNames.contains(flightName);

  List<PrettyFlight> filter(List<PrettyFlight> prettyFlights) {
    final flights = <PrettyFlight>[];

    for (final flight in prettyFlights) {
      if (_flightNames.contains(flight.name)) {
        flights.add(flight);
      }
    }

    return flights;
  }
}
