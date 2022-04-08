// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/hexagon_border.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/screen_adjust.dart';

/// A button with an icon and a hexagon border.
class HexagonButton extends StatelessWidget {
  const HexagonButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.tip,
    this.color,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;

  final String tip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      //TODO FIx in landscape too small
      heightFactor: 1 + screenAdjustY(0.0003, context),
      child: IconFlatHexagonButton(
        onPressed: onPressed,
        tip: tip,
        icon: icon,
        iconSize: screenAdjustNormalIconSize(context),
        color: color,
      ),
    );
  }
}

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
  const IconFlatHexagonButton({
    Key? key,
    this.onPressed,
    required this.tip,
    required this.icon,
    required this.iconSize,
    this.color,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String tip;

  final IconData icon;
  final double iconSize;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FlatHexagonButton(
      onPressed: onPressed,
      tip: tip,
      child: Icon(
        icon,
        color:
            color ?? (onPressed != null ? Hue.enabledIcon : Hue.disabledIcon),
        size: iconSize,
      ),
    );
  }
}
