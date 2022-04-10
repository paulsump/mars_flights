// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';

/// Access to all the colors in the app
class Hue {
  static const Color iconDeselected = Color(0xffA57C3E);
  static const Color iconSelected = Color(0xffFFCA99);

  static const Color favorite = Color(0xffFE0000);
  static const Color notFavorite = iconSelected;

  static const Color text = Color(0xffFFE99D);
  static const Color background = Color(0xff281721);

  static const Color buttonOverlay = background;
  static const Color buttonBorder = Color(0xffFFC260);

  static final Color buttonBackground = buttonBorder.withOpacity(0.1);
  static const Color tableColor = Color(0xff003446);
}
