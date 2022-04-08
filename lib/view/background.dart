// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/page_buttons.dart';
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
                size: isPortrait(context) ? 0.022 : 0.07,
              ),
            ),
            SafeArea(
              left: false,
              child: Column(
                children: [
                  const PageButtons(),
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
