// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/current_page.dart';

const unitOffset = Offset(1.0, 1.0);

/// Calculate a value between 0 and 1 but goes up and down like a sine wave.
double _calcUnitPingPong(double unitValue) => (1 + sin(2 * pi * unitValue)) / 2;

/// A container frame / scaffold for all pages.
/// It has the background color and image and a silly little [_Star] animation.
class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

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
                    const CurrentPageTitle(),
                    Column(
                      children: [
                        const CurrentPageButtons(),
                        SizedBox(height: screenAdjustY(0.02, context)),
                        const Expanded(child: Center(child: CurrentPage())),
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

    final center = unitOffset * _calcUnitPingPong(_controller.value);
    final offset = Offset(size.width * center.dx, size.height * center.dy);

    final imageSize = unitOffset * 128;

    return Transform.translate(
      offset: offset - imageSize / 2,
      child: const Pulsate(
          scale: 0.4, child: Image(image: AssetImage('images/star.png'))),
    );
  }
}

/// Animates a child (e.g. an image) to throb / scale in and out
/// with a sinusoidal ping pong / resonant oscillation.
class Pulsate extends StatefulWidget {
  const Pulsate({
    Key? key,
    required this.child,
    required this.scale,
  }) : super(key: key);

  final Widget child;
  final double scale;

  @override
  _PulsateState createState() => _PulsateState();
}

class _PulsateState extends State<Pulsate> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 30), vsync: this)
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
    final from = isPortrait(context) ? 1.15 : 1.05;

    return Transform.scale(
      scale: lerpDouble(
        from * widget.scale,
        1.6 * widget.scale,
        _calcUnitPingPong(_controller.value),
      )!,
      child: widget.child,
    );
  }
}
