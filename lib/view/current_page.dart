// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/countdown_page.dart';
import 'package:mars_flights/view/upcoming_launches_page.dart';
import 'package:provider/provider.dart';

const unitOffset = Offset(1.0, 1.0);

/// For switching the current page
enum _PageId { countdown, upcomingLaunches, favorites }

/// Instead of Navigator, this class changes the current page displayed
class CurrentPageNotifier extends ChangeNotifier {
  _PageId pageId = _PageId.countdown;

  void setPage(_PageId pageId_) {
    pageId = pageId_;
    notifyListeners();
  }
}

/// the current page that is displayed
class CurrentPage extends StatelessWidget {
  CurrentPage({Key? key}) : super(key: key);

  final _pages = <_PageId, Widget>{
    _PageId.countdown: const CountdownPage(),
    _PageId.upcomingLaunches: const UpcomingLaunchesPage(),
    _PageId.favorites: const FavoritesPage(),
  };

  @override
  Widget build(BuildContext context) {
    final currentPageNotifier =
        Provider.of<CurrentPageNotifier>(context, listen: true);

    return _pages[currentPageNotifier.pageId]!;
  }
}

/// The title at the top of the current page.
class CurrentPageTitle extends StatelessWidget {
  CurrentPageTitle({Key? key}) : super(key: key);

  final _titles = <_PageId, String>{
    _PageId.upcomingLaunches: 'Upcoming Launches',
    _PageId.favorites: 'Favorite Upcoming Launches',
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
    final currentPageNotifier =
        Provider.of<CurrentPageNotifier>(context, listen: true);

    if (currentPageNotifier.pageId == _PageId.countdown) {
      final fetchNotifier = getFetchNotifier(context, listen: true);

      final Launch? flight =
          fetchNotifier.hasNextLaunch ? fetchNotifier.flight : null;

      final String? name = flight?.name;
      return name == null ? 'Next Launch' : 'Upcoming: $name';
    }

    return _titles[currentPageNotifier.pageId]!;
  }
}

/// A container for all the buttons on all pages
/// Organised using [Column]s and [Row]s
class CurrentPageButtons extends StatelessWidget {
  const CurrentPageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPageNotifier =
        Provider.of<CurrentPageNotifier>(context, listen: true);

    VoidCallback _gotoPage(pageId) => () => currentPageNotifier.setPage(pageId);

    bool _isCurrentPage(pageId) => currentPageNotifier.pageId == pageId;

    Color _getColor(pageId) =>
        _isCurrentPage(pageId) ? Hue.iconSelected : Hue.iconDeselected;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconFlatHexagonButton(
          onPressed: _gotoPage(_PageId.countdown),
          icon: Icons.timer_rounded,
          tip: 'Show the time left until the next launch.',
          color: _getColor(_PageId.countdown),
        ),
        IconFlatHexagonButton(
          onPressed: _gotoPage(_PageId.upcomingLaunches),
          icon: Icons.view_list_rounded,
          tip: 'Show all the upcoming launches.',
          color: _getColor(_PageId.upcomingLaunches),
        ),
        FlatHexagonButton(
          onPressed: _gotoPage(_PageId.favorites),
          tip: 'Show your favorite upcoming launches',
          child: _IconPair(selected: _isCurrentPage(_PageId.favorites)),
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
