// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/favorites_notifier.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/retry_fetch.dart';

/// All the upcoming launches
class UpcomingLaunchesPage extends StatelessWidget {
  const UpcomingLaunchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    return fetchNotifier.hasUpcomingLaunches
        ? _ScrollTable(prettyFlights: fetchNotifier.prettyFlights)
        : RetryFetch(message: fetchNotifier.upcomingLaunchesErrorMessage);
  }
}

/// The users favorite (bookmarked) upcoming launches.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    final favoritesNotifier = getFavoritesNotifier(context, listen: true);

    return fetchNotifier.hasUpcomingLaunches
        ? _ScrollTable(
            prettyFlights:
                favoritesNotifier.filter(fetchNotifier.prettyFlights))
        : RetryFetch(message: fetchNotifier.upcomingLaunchesErrorMessage);
  }
}

/// Allows horizontal scroll of table in portrait only.
class _ScrollTable extends StatelessWidget {
  const _ScrollTable({Key? key, required this.prettyFlights}) : super(key: key);

  final List<PrettyFlight> prettyFlights;

  @override
  Widget build(BuildContext context) {
    return isPortrait(context)
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _Table(prettyFlights),
          )
        : _Table(prettyFlights);
  }
}

/// A data table showing upcoming launches (all or favorites).
class _Table extends StatelessWidget {
  const _Table(this.prettyFlights, {Key? key}) : super(key: key);

  final List<PrettyFlight> prettyFlights;

  @override
  Widget build(BuildContext context) {
    final size = isPortrait(context) ? 0.02 : 0.04;

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
          for (final prettyFlight in prettyFlights)
            DataRow(
              cells: <DataCell>[
                cellText(prettyFlight.name),
                cellText(prettyFlight.date),
                cellText(prettyFlight.pad),
                DataCell(_FavoritesToggleButton(id: prettyFlight.id)),
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
      child: ScreenAdjustedToolTip(
        message: 'Add this flight to favorites.',
        child: IconButton(
          onPressed: () => favoritesNotifier.toggle(id),
          icon: Icon(
            favoritesNotifier.contains(id)
                ? Icons.favorite
                : Icons.favorite_border,
            color:
                favoritesNotifier.contains(id) ? Hue.favorite : Hue.notFavorite,
          ),
          iconSize: screenAdjustSmallIconSize(context),
        ),
      ),
    );
  }
}
