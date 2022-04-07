// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/bookmarks_notifier.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/hue.dart';
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
            ? isPortrait(context)
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _Table(fetchNotifier.prettyFlights),
                  )
                : _Table(fetchNotifier.prettyFlights)
            : Container());
  }
}

class _Table extends StatelessWidget {
  const _Table(this.flights, {Key? key}) : super(key: key);

  final List<PrettyFlight> flights;

  @override
  Widget build(BuildContext context) {
    final size = isPortrait(context) ? 0.013 : 0.04;

    column(label) => DataColumn(label: ScreenAdjustedText(label, size: size));
    cell(value) => DataCell(ScreenAdjustedText(value, size: size));

    return SingleChildScrollView(
      child: DataTable(
        columns: <DataColumn>[
          column('Mission'),
          column('Date (UTC)'),
          column('Launch Pad'),
          column('Favorite'),
        ],
        rows: <DataRow>[
          for (final flight in flights)
            DataRow(
              cells: <DataCell>[
                cell(flight.mission),
                cell(flight.date),
                cell(flight.pad),
                DataCell(_HeartButton(name: flight.mission)),
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
  const _HeartButton({required this.name, Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final bookmarksNotifier = getBookmarksNotifier(context, listen: true);

    return Align(
      heightFactor: 0.774,
      child: Tooltip(
        message: 'Bookmark this flight as a favorite',
        child: IconButton(
          onPressed: () => bookmarksNotifier.add(name),
          icon: Icon(
            Icons.favorite,
            color: bookmarksNotifier.isBookmarked(name)
                ? Hue.favorite
                : Hue.notFavorite,
          ),
          iconSize: screenAdjustSmallIconSize(context),
        ),
      ),
    );
  }
}
