import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Convenience function to get the [BookmarksNotifier] '[Provider]'.
BookmarksNotifier getBookmarksNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<BookmarksNotifier>(context, listen: listen);

/// Access to the list of bookmarked ('favorite') flights.
class BookmarksNotifier extends ChangeNotifier {
  final flightIds = <String>[];

  void add(String flightId) {
    flightIds.add(flightId);
  }
}
