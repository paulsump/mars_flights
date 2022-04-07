import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Convenience function to get the [FavoritesNotifier] '[Provider]'.
FavoritesNotifier getFavoritesNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<FavoritesNotifier>(context, listen: listen);

/// Access to the list of favorite flights.
class FavoritesNotifier extends ChangeNotifier {
  final _flightNames = <String>[];

  void add(String flightName) {
    _flightNames.add(flightName);

    notifyListeners();
    //TODO LOCAL STORAGE FOR NEXT RUN
  }

  bool contains(String flightName) => _flightNames.contains(flightName);
}
