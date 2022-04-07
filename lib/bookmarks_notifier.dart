import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Convenience function to get the [BookmarksNotifier] '[Provider]'.
BookmarksNotifier getBookmarksNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<BookmarksNotifier>(context, listen: listen);

/// Access to the list of bookmarked ('favorite') flights.
class BookmarksNotifier extends ChangeNotifier {
  final _flightNames = <String>[];

  void add(String flightName) {
    _flightNames.add(flightName);

    notifyListeners();
    //TODO LOCAL STORAGE FOR NEXT RUN
  }

  bool isBookmarked(String flightName) => _flightNames.contains(flightName);
}
