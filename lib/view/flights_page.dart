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
      title: 'Upcoming Launches',
      child: fetchNotifier.hasFlights
          ? _ScrollTable(flights: fetchNotifier.prettyFlights)
          // TODO DISplay flightsErrorMessage
          : Container(),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    final favoritesNotifier = getFavoritesNotifier(context, listen: true);

    return Background(
      title: 'Favorite Upcoming Launches',
      child: fetchNotifier.hasFlights
          ? _ScrollTable(
              flights: favoritesNotifier.filter(fetchNotifier.prettyFlights))
          // TODO DISplay flightsErrorMessage
          : Container(),
    );
  }
}

/// Allows horizontal scroll of table in portrait only.
class _ScrollTable extends StatelessWidget {
  const _ScrollTable({
    Key? key,
    required this.flights,
  }) : super(key: key);

  final List<PrettyFlight> flights;

  @override
  Widget build(BuildContext context) {
    return isPortrait(context)
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _Table(flights),
          )
        : _Table(flights);
  }
}

class _Table extends StatelessWidget {
  const _Table(this.flights, {Key? key}) : super(key: key);

  final List<PrettyFlight> flights;

  @override
  Widget build(BuildContext context) {
    final size = isPortrait(context) ? 0.013 : 0.03;

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
                cellText(flight.name),
                cellText(flight.date),
                cellText(flight.pad),
                DataCell(_FavoritesToggleButton(id: flight.id)),
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
  const _FavoritesToggleButton({required this.id, Key? key}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = getFavoritesNotifier(context, listen: true);

    return Align(
      heightFactor: 0.774,
      child: Tooltip(
        message: 'Add this flight to favorites.',
        child: IconButton(
          onPressed: () => favoritesNotifier.toggle(id),
          icon: Icon(
            Icons.favorite,
            color:
                favoritesNotifier.contains(id) ? Hue.favorite : Hue.notFavorite,
          ),
          iconSize: screenAdjustSmallIconSize(context),
        ),
      ),
    );
  }
}
