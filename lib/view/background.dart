// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/pulsate.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';

const _unitOffset = Offset(1.0, 1.0);

/// A container frame / scaffold for all pages.
/// It has the background color and image and a silly little [_Star] animation.
class Background extends StatelessWidget {
  const Background({
    Key? key,
    required this.child,
    required this.title,
  }) : super(key: key);

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Hue.background,
        child: Stack(
          children: [
            const Center(
              child: Pulsate(
                scale: 2.0,
                child: Image(image: AssetImage('images/background.jpg')),
              ),
            ),
            const _Star(),
            ScreenAdjust(
              portrait: const Offset(0.25, 1.5),
              landscape: const Offset(0.3, 1.6),
              child: ScreenAdjustedText(
                title,
                size: isPortrait(context) ? 0.022 : 0.06,
              ),
            ),
            SafeArea(
              left: false,
              child: Column(
                children: [
                  const _PageButtons(),
                  Expanded(child: Center(child: child)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A container for all the buttons on all pages
/// Organised using [Column]s and [Row]s
class _PageButtons extends StatelessWidget {
  const _PageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconFlatHexagonButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('Countdown'),
            icon: Icons.timer_rounded,
            tip: 'Show the time left until the next launch.'),
        IconFlatHexagonButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('Flights'),
            icon: Icons.view_list_rounded,
            tip: 'Show all the upcoming launches.'),
        FlatHexagonButton(
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('Favorites'),
          tip: 'Show your favorite upcoming launches',
          child: const _IconPair(),
        ),
      ],
    );
  }
}

/// Nice favorites button using pair of icons
class _IconPair extends StatelessWidget {
  const _IconPair({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final n = screenAdjustNormalIconSize(context);

    return Stack(
      children: [
        Icon(
          Icons.view_list_rounded,
          color: Hue.enabledIcon,
          size: n,
        ),
        Transform.translate(
          offset: _unitOffset * 0.2 * n,
          child: Transform.scale(
            scale: 0.7,
            child: Icon(
              Icons.favorite,
              color: Hue.favorite,
              size: n,
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
