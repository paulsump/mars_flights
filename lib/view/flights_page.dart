// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/bookmarks_notifier.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/background.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';

class FlightsPage extends StatelessWidget {
  const FlightsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    return Background(
        child: fetchNotifier.hasFlights
            ? _Table(fetchNotifier.flights)
            : Container());
  }
}

class _Table extends StatelessWidget {
  const _Table(this.flights, {Key? key}) : super(key: key);

  final List<Flight> flights;

  @override
  Widget build(BuildContext context) {
    //TODO SCREEN Size adjust
    const size = 0.025;

    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: ScreenAdjustedText('Mission', size: size)),
          DataColumn(label: ScreenAdjustedText('Date (UTC)', size: size)),
          DataColumn(label: ScreenAdjustedText('Launch Pad', size: size)),
          DataColumn(label: ScreenAdjustedText('Favorite', size: size)),
        ],
        rows: <DataRow>[
          for (final flight in flights)
            DataRow(
              cells: <DataCell>[
                DataCell(ScreenAdjustedText(flight.id!, size: size)),
                DataCell(
                    ScreenAdjustedText(flight.time.toString(), size: size)),
                DataCell(ScreenAdjustedText(flight.launchPad!, size: size)),
                DataCell(_HeartButton(flightId: flight.id!)),
              ],
            ),
        ],
      ),
    );
  }
}

/// A button with an icon on it, that, when pressed
/// toggles this flight as a favorite or not.
class _HeartButton extends StatelessWidget {
  const _HeartButton({required this.flightId, Key? key}) : super(key: key);

  final String flightId;

  @override
  Widget build(BuildContext context) {
    final bookmarksNotifier = getBookmarksNotifier(context, listen: false);
    return Align(
      heightFactor: 0.774,
      child: IconFlatHexagonButton(
        onPressed: () => bookmarksNotifier.add(flightId),
        tip: 'Bookmark this flight as a favorite',
        icon: Icons.favorite,
        iconSize: screenAdjustSmallIconSize(context),
      ),
    );
  }
}
