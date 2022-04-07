import 'package:flutter/material.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:provider/provider.dart';

/// Convenience function to get the [FavoritesNotifier] '[Provider]'.
FavoritesNotifier getFavoritesNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<FavoritesNotifier>(context, listen: listen);

/// Access to the list of favorite flights.
class FavoritesNotifier extends ChangeNotifier {
  final _flightIds = <String>[];

  void toggle(String flightId) {
    if (_flightIds.contains(flightId)) {
      _flightIds.remove(flightId);
    } else {
      _flightIds.add(flightId);
    }

    notifyListeners();
    //TODO LOCAL STORAGE FOR NEXT RUN
  }

  bool contains(String flightId) => _flightIds.contains(flightId);

  List<PrettyFlight> filter(List<PrettyFlight> prettyFlights) {
    final flights = <PrettyFlight>[];

    for (final flight in prettyFlights) {
      if (_flightIds.contains(flight.id)) {
        flights.add(flight);
      }
    }

    return flights;
  }
}
