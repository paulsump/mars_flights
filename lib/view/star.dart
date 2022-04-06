// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/view/pulsate.dart';
import 'package:mars_flights/screen_adjust.dart';

/// Little animated stars on the [Background]
class Star extends StatefulWidget {
  const Star({Key? key}) : super(key: key);

  @override
  _StarState createState() => _StarState();
}

class _StarState extends State<Star> with SingleTickerProviderStateMixin {
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

    const unit = Offset(1, 1);
    final center = unit * calcUnitPingPong(_controller.value);

    final offset = Offset(size.width * center.dx, size.height * center.dy);
    final imageSize = unit * 128;

    return Transform.translate(
      offset: offset - imageSize / 2,
      child: const Pulsate(child: Image(image: AssetImage('images/star.png'))),
    );
  }
}
