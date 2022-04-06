// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/screen_adjust.dart';

/// A container for all the buttons on the main [PainterPage].
///
/// Organised using [Column]s and [Row]s
class PageButtons extends StatelessWidget {
  const PageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        _IconButton(icon: Icons.timer_rounded),
        _IconButton(icon: Icons.view_list_rounded),
        _IconButton(icon: Icons.favorite),
      ],
    );
  }
}

/// A button with an icon on it.
/// For [PageButtons].
class _IconButton extends StatelessWidget {
  const _IconButton({Key? key, required this.icon}) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 0.774,
      child: IconFlatHexagonButton(
        //TODO NAV
        onPressed: () => {},
        //TODO tip
        tip: 'TODO',
        icon: icon,
        iconSize: screenAdjustNormalIconSize(context),
      ),
    );
  }
}
