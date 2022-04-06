// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:mars_flights/buttons/hexagon_border.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:flutter/material.dart';

/// Transparent flat hexagon shaped [TextButton] (without text).
class FlatHexagonButton extends StatelessWidget {
  const FlatHexagonButton({
    Key? key,
    this.onPressed,
    required this.tip,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String tip;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenAdjustButtonWidth(context),
      child: Tooltip(
        message: tip,
        child: TextButton(
          child: child,
          onPressed: onPressed,
          style: ButtonStyle(
            shape: hexagonBorderShape,
            fixedSize:
                MaterialStateProperty.all(screenAdjustButtonSize(context)),
            backgroundColor: MaterialStateProperty.all(Hue.buttonBackground),
            overlayColor:
                MaterialStateColor.resolveWith((states) => Hue.buttonOverlay),
          ),
        ),
      ),
    );
  }
}

/// A [FlatHexagonButton] with an icon.
class IconFlatHexagonButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tip;
  final IconData icon;
  final double iconSize;

  const IconFlatHexagonButton({
    Key? key,
    this.onPressed,
    required this.tip,
    required this.icon,
    required this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatHexagonButton(
      onPressed: onPressed,
      tip: tip,
      child: Icon(
        icon,
        color: onPressed != null ? Hue.enabledIcon : Hue.disabledIcon,
        size: iconSize,
      ),
    );
  }
}
