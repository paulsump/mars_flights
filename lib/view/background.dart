// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/view/hue.dart';
import 'package:mars_flights/view/star.dart';

/// A container frame / scaffold for all pages.
/// It has the background color and image and a silly little [Star] animation.
class Background extends StatelessWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Hue.background,
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            const Star(),
            SafeArea(left: false, child: Center(child: child)),
          ],
        ),
      ),
    );
  }
}
