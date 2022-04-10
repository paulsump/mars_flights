// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';

/// Access to all the colors in the app
class Hue {
  static const Color iconDeselected = Color(0xffA57C3E);
  static const Color iconSelected = Color(0xffFFCA99);

  static const Color favorite = Color(0xffFE0000);
  static const Color notFavorite = iconSelected;

  static const Color text = Color(0xffFFE99D);
  static const Color lightBackground = Color(0xff0987C5);
  static const Color _darkBackground = Color(0xff015472);

  static const Color buttonBorder = lightBackground;
  static const Color buttonOverlay = _darkBackground;

  static final Color buttonBackground = _darkBackground.withOpacity(0.1);
  static const Color toolTip = _darkBackground;
}
