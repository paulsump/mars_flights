// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/position_to_unit.dart';
import 'package:mars_flights/hue.dart';

/// Convenient access to screen dimensions.
Size getScreenSize(BuildContext context) => MediaQuery.of(context).size;

/// Device orientation access.
bool isPortrait(BuildContext context) =>
    MediaQuery.of(context).orientation == Orientation.portrait;

/// Widget dimensions calculated using the width of the screen.
double screenAdjustX(double length, BuildContext context) =>
    length * screenWidth(context);

/// Widget dimensions calculated using the height of the screen.
double screenAdjustY(double length, BuildContext context) =>
    length * screenHeight(context);

/// object dimensions calculated using the shortestEdge of the screen...

double screenAdjust(double length, BuildContext context) =>
    length * _getScreenShortestEdge(context);

double _getScreenShortestEdge(BuildContext context) {
  final screen = getScreenSize(context);

  return min(screen.width, screen.height);
}

double _screenAdjustButtonHeight(BuildContext context) =>
    33 + screenAdjustY(isPortrait(context) ? 0.06 : 0.11, context);

double screenAdjustButtonWidth(BuildContext context) =>
    root3over2 * _screenAdjustButtonHeight(context);

Size screenAdjustButtonSize(BuildContext context) {
  final double buttonHeight = _screenAdjustButtonHeight(context);

  return Size(buttonHeight, buttonHeight);
}

double screenAdjustNormalIconSize(BuildContext context) =>
    0.45 * _screenAdjustButtonHeight(context);

double screenAdjustSmallIconSize(BuildContext context) =>
    0.34 * _screenAdjustButtonHeight(context);

/// Device dimensions
double screenWidth(BuildContext context) => getScreenSize(context).width;

/// Device dimensions
double screenHeight(BuildContext context) => getScreenSize(context).height;

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

    final w = screenWidth(context);
    final h = screenHeight(context);

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

/// Simple [Text] with screen adjusted font size.
class ScreenAdjustedText extends StatelessWidget {
  const ScreenAdjustedText(
    this.text, {
    Key? key,
    this.bold = false,
    this.italic = false,
    this.size = 0.03,
  }) : super(key: key);

  final String text;

  final bool bold, italic;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Hue.text,
        // TODO  size isPortrait()?:
        fontSize: screenAdjustY(size, context),
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }
}

class ScreenAdjustedToolTip extends StatelessWidget {
  const ScreenAdjustedToolTip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fontSize = screenAdjustY(isPortrait(context) ? 0.016 : 0.03, context);

    return Tooltip(
      message: message,
      child: child,
      // TODO  size isPortrait()?:
      // TODO  screenAdjustY
      verticalOffset: 55,
      padding: const EdgeInsets.all(16),
      textStyle: TextStyle(
        color: Hue.text,
        fontSize: fontSize,
      ),
      decoration: const BoxDecoration(color: Hue.toolTip),
    );
  }
}
