// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/countdown_page.dart';
import 'package:mars_flights/view/flights_page.dart';
import 'package:mars_flights/view/pulsate.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';
import 'package:provider/provider.dart';

const _unitOffset = Offset(1.0, 1.0);

/// A container frame / scaffold for all pages.
/// It has the background color and image and a silly little [_Star] animation.
class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: Hue.lightBackground,
          child: Stack(
            children: [
              const Center(
                child: Pulsate(
                  scale: 2.0,
                  child: Image(image: AssetImage('images/background.jpg')),
                ),
              ),
              const _Star(),
              SafeArea(
                left: false,
                child: Stack(
                  children: [
                    _CurrentPageTitle(),
                    Column(
                      children: [
                        const _PageButtons(),
                        Expanded(child: Center(child: _CurrentPage())),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageNotifier extends ChangeNotifier {
  String pageName = 'Countdown';

  void setPage(String pageName_) {
    pageName = pageName_;
    notifyListeners();
  }
}

class _CurrentPage extends StatelessWidget {
  _CurrentPage({Key? key}) : super(key: key);

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

class _CurrentPageTitle extends StatelessWidget {
  _CurrentPageTitle({Key? key}) : super(key: key);

  final _titles = <String, String>{
    'Flights': 'Upcoming Launches',
    'Favorites': 'Favorite Upcoming Launches',
  };

  @override
  Widget build(BuildContext context) {
    return ScreenAdjust(
      portrait: const Offset(0.25, 1.8),
      landscape: const Offset(0.2, 0.72),
      child: ScreenAdjustedText(
        _getTitle(context),
        size: isPortrait(context) ? 0.022 : 0.07,
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
class _PageButtons extends StatelessWidget {
  const _PageButtons({Key? key}) : super(key: key);

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
          child: IconPair(selected: _isCurrentPage('Favorites')),
        ),
      ],
    );
  }
}

/// Nice favorites button using pair of icons.
/// (A list icon with a heart in bottom right corner).
class IconPair extends StatelessWidget {
  const IconPair({Key? key, required this.selected}) : super(key: key);

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
          offset: _unitOffset * 0.2 * size,
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

/// Little animated stars on the [Background]
class _Star extends StatefulWidget {
  const _Star({Key? key}) : super(key: key);

  @override
  _StarState createState() => _StarState();
}

class _StarState extends State<_Star> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 80000), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = getScreenSize(context);

    final center = _unitOffset * calcUnitPingPong(_controller.value);
    final offset = Offset(size.width * center.dx, size.height * center.dy);

    final imageSize = _unitOffset * 128;

    return Transform.translate(
      offset: offset - imageSize / 2,
      child: const Pulsate(
          scale: 0.4, child: Image(image: AssetImage('images/star.png'))),
    );
  }
}
