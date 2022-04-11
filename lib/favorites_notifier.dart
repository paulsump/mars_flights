import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Convenience function to get the [FavoritesNotifier] '[Provider]'.
FavoritesNotifier getFavoritesNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<FavoritesNotifier>(context, listen: listen);

/// Access to the list of favorite upcomingLaunches.
class FavoritesNotifier extends ChangeNotifier {
  final _flightIds = <String>[];

  bool loadHasBeenCalled = false;

  void toggle(String flightId) {
    if (_flightIds.contains(flightId)) {
      _flightIds.remove(flightId);
    } else {
      _flightIds.add(flightId);
    }

    notifyListeners();
    unawaited(_save());
  }

  bool contains(String flightId) => _flightIds.contains(flightId);

  List<FormattedUpcomingLaunch> filter(
      List<FormattedUpcomingLaunch> formattedUpcomingLaunches) {
    final formattedUpcomingLaunches_ = <FormattedUpcomingLaunch>[];

    for (final formattedUpcomingLaunch in formattedUpcomingLaunches) {
      if (_flightIds.contains(formattedUpcomingLaunch.id)) {
        formattedUpcomingLaunches_.add(formattedUpcomingLaunch);
      }
    }

    return formattedUpcomingLaunches_;
  }

  Future<void>? loadInitialValues() async {
    final preferences = await SharedPreferences.getInstance();

    final List<String>? favorites = preferences.getStringList('favorites');

    if (favorites != null) {
      _flightIds.addAll(favorites);
    }

    loadHasBeenCalled = true;
  }

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();

    unawaited(preferences.setStringList('favorites', _flightIds));
  }
}
