// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/countdown_page.dart';
import 'package:mars_flights/view/flights_page.dart';
import 'package:provider/provider.dart';

const unitOffset = Offset(1.0, 1.0);

class PageNotifier extends ChangeNotifier {
  String pageName = 'Countdown';

  void setPage(String pageName_) {
    pageName = pageName_;
    notifyListeners();
  }
}

class CurrentPage extends StatelessWidget {
  CurrentPage({Key? key}) : super(key: key);

  final _pages = <String, Widget>{
    'Countdown': const CountdownPage(),
    'Flights': const FlightsPage(),
    'Favorites': const FavoritesPage(),
  };

  @override
  Widget build(BuildContext context) {
    final pageNotifier = Provider.of<PageNotifier>(context, listen: true);
    return _pages[pageNotifier.pageName]!;
  }
}

class CurrentPageTitle extends StatelessWidget {
  CurrentPageTitle({Key? key}) : super(key: key);

  final _titles = <String, String>{
    'Flights': 'Upcoming Launches',
    'Favorites': 'Favorite Upcoming Launches',
  };

  @override
  Widget build(BuildContext context) {
    return ScreenAdjust(
      portrait: const Offset(0.37, 1.9),
      landscape: const Offset(0.3, 0.79),
      child: ScreenAdjustedText(
        _getTitle(context),
        size: isPortrait(context) ? 0.025 : 0.07,
      ),
    );
  }

  String _getTitle(BuildContext context) {
    final pageNotifier = Provider.of<PageNotifier>(context, listen: true);

    if (pageNotifier.pageName == 'Countdown') {
      final fetchNotifier = getFetchNotifier(context, listen: true);

      final Flight? flight =
          fetchNotifier.hasFlight ? fetchNotifier.flight : null;

      final String? name = flight?.name;
      return name == null ? 'Next Launch' : 'Upcoming: $name';
    }

    return _titles[pageNotifier.pageName]!;
  }
}

/// A container for all the buttons on all pages
/// Organised using [Column]s and [Row]s
class CurrentPageButtons extends StatelessWidget {
  const CurrentPageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageNotifier = Provider.of<PageNotifier>(context, listen: true);

    VoidCallback _gotoPage(pageName) => () => pageNotifier.setPage(pageName);
    bool _isCurrentPage(pageName) => pageNotifier.pageName == pageName;

    Color _getColor(pageName) =>
        _isCurrentPage(pageName) ? Hue.iconSelected : Hue.iconDeselected;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconFlatHexagonButton(
          onPressed: _gotoPage('Countdown'),
          icon: Icons.timer_rounded,
          tip: 'Show the time left until the next launch.',
          color: _getColor('Countdown'),
        ),
        IconFlatHexagonButton(
          onPressed: _gotoPage('Flights'),
          icon: Icons.view_list_rounded,
          tip: 'Show all the upcoming launches.',
          color: _getColor('Flights'),
        ),
        FlatHexagonButton(
          onPressed: _gotoPage('Favorites'),
          tip: 'Show your favorite upcoming launches',
          child: _IconPair(selected: _isCurrentPage('Favorites')),
        ),
      ],
    );
  }
}

/// Nice favorites button using pair of icons.
/// (A list icon with a heart in bottom right corner).
class _IconPair extends StatelessWidget {
  const _IconPair({Key? key, required this.selected}) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final size = screenAdjustNormalIconSize(context);

    return Stack(
      children: [
        Icon(
          Icons.view_list_rounded,
          color: selected ? Hue.iconSelected : Hue.iconDeselected,
          size: size,
        ),
        Transform.translate(
          offset: unitOffset * 0.2 * size,
          child: Transform.scale(
            scale: 0.7,
            child: Icon(
              Icons.favorite,
              color: Hue.favorite,
              size: size,
            ),
          ),
        ),
      ],
    );
  }
}
