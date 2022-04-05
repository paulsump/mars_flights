// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'dart:math';

import 'package:flutter/material.dart';

/// Convenient access to screen dimensions.
Size getScreenSize(BuildContext context) => MediaQuery.of(context).size;

/// Device orientation access.
bool isPortrait(BuildContext context) {
  final screen = getScreenSize(context);
  return screen.width < screen.height;
}

/// Widget dimensions calculated using the shortestEdge of the screen.
double screenAdjust(double length, BuildContext context) =>
    length * _getScreenShortestEdge(context);

/// Widget dimensions calculated using the width of the screen.
double screenAdjustX(double length, BuildContext context) =>
    length * _getScreenWidth(context);

/// Widget dimensions calculated using the height of the screen.
double screenAdjustY(double length, BuildContext context) =>
    length * _getScreenHeight(context);

double _getScreenShortestEdge(BuildContext context) {
  final screen = getScreenSize(context);

  return min(screen.width, screen.height);
}

/// Device dimensions
double _getScreenWidth(BuildContext context) => getScreenSize(context).width;

/// Device dimensions
double _getScreenHeight(BuildContext context) => getScreenSize(context).height;

/// Translate a child widget by an amount relative to
/// the dimensions of the device.
class ScreenAdjust extends StatelessWidget {
  const ScreenAdjust({
    Key? key,
    required this.portrait,
    required this.landscape,
    this.width,
    required this.child,
    this.anchorBottom = false,
    this.anchorRight = false,
  }) : super(key: key);

  final Offset portrait, landscape;
  final double? width;
  final Widget child;

  /// anchor from the bottom upwards instead of the default top downwards
  final bool anchorBottom;

  /// anchor from the right leftwards instead of the default left rightwards!
  final bool anchorRight;

  @override
  Widget build(BuildContext context) {
    final offset1 = (isPortrait(context) ? portrait : landscape);

    final offset_ = Offset(offset1.dx * screenAdjustX(0.13, context),
        offset1.dy * screenAdjustY(0.06, context));

    final w = _getScreenWidth(context);
    final h = _getScreenHeight(context);

    final offset = Offset(anchorRight ? w - offset_.dx : offset_.dx,
        anchorBottom ? h - offset_.dy : offset_.dy);

    return Transform.translate(
      offset: offset,
      child: width != null
          ? SizedBox(
              width: (anchorBottom && !anchorRight)
                  ? width! * h
                  : screenAdjustX(width!, context),
              child: child)
          : child,
    );
  }
}
