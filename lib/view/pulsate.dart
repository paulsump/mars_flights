// © 2022, Paul Sumpner <sumpner@hotmail.com>
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mars_flights/out.dart';
import 'package:mars_flights/screen_adjust.dart';

/// Calculate a value between 0 and 1 but goes up and down like a sine wave.
double calcUnitPingPong(double unitValue) => (1 + sin(2 * pi * unitValue)) / 2;

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
    _controller = AnimationController(
        duration: const Duration(milliseconds: 30000), vsync: this)
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
    final from = isPortrait(context) ? 1.15 : 1.0;

    final s = widget.scale;

    return Transform.scale(
      scale:
          lerpDouble(from * s, 2.4 * s, calcUnitPingPong(_controller.value))!,
      child: widget.child,
    );
  }
}
