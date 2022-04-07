// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/favorites_notifier.dart';
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

    columnHeader(label) =>
        DataColumn(label: ScreenAdjustedText(label, size: size));
    cellText(value) => DataCell(ScreenAdjustedText(value, size: size));

    return SingleChildScrollView(
      child: DataTable(
        columns: <DataColumn>[
          columnHeader('Mission'),
          columnHeader('Date (UTC)'),
          columnHeader('Launch Pad'),
          columnHeader('Favorite'),
        ],
        rows: <DataRow>[
          for (final flight in flights)
            DataRow(
              cells: <DataCell>[
                cellText(flight.mission),
                cellText(flight.date),
                cellText(flight.pad),
                DataCell(_FavoritesToggleButton(name: flight.mission)),
              ],
            ),
        ],
      ),
    );
  }
}

/// A button with an icon on it, that, when pressed
/// toggles this flight as a favorite or not.
class _FavoritesToggleButton extends StatelessWidget {
  const _FavoritesToggleButton({required this.name, Key? key})
      : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = getFavoritesNotifier(context, listen: true);

    return Align(
      heightFactor: 0.774,
      child: Tooltip(
        message: 'Add this flight to favorites.',
        child: IconButton(
          onPressed: () => favoritesNotifier.toggle(name),
          icon: Icon(
            Icons.favorite,
            color: favoritesNotifier.contains(name)
                ? Hue.favorite
                : Hue.notFavorite,
          ),
          iconSize: screenAdjustSmallIconSize(context),
        ),
      ),
    );
  }
}
