// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/hexagon_button.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/pulsate.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';
import 'package:mars_flights/view/star.dart';

/// A container frame / scaffold for all pages.
/// It has the background color and image and a silly little [Star] animation.
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
            const Star(),
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
        HexagonButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('Countdown'),
            icon: Icons.timer_rounded,
            tip: 'Show the time left until the next launch.'),
        HexagonButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('Flights'),
            icon: Icons.view_list_rounded,
            tip: 'Show all the upcoming launches.'),
      ],
    );
  }
}
