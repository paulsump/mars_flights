// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/current_page.dart';
import 'package:mars_flights/view/pulsate.dart';

const unitOffset = Offset(1.0, 1.0);

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
                    CurrentPageTitle(),
                    Column(
                      children: [
                        const CurrentPageButtons(),
                        Expanded(child: Center(child: CurrentPage())),
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

    final center = unitOffset * calcUnitPingPong(_controller.value);
    final offset = Offset(size.width * center.dx, size.height * center.dy);

    final imageSize = unitOffset * 128;

    return Transform.translate(
      offset: offset - imageSize / 2,
      child: const Pulsate(
          scale: 0.4, child: Image(image: AssetImage('images/star.png'))),
    );
  }
}
