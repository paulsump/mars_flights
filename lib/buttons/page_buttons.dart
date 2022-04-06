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
        _IconButton(pageName: 'Countdown', icon: Icons.timer_rounded),
        _IconButton(pageName: 'Flights', icon: Icons.view_list_rounded),
        _IconButton(pageName: 'Favorites', icon: Icons.favorite),
      ],
    );
  }
}

/// A button with an icon on it.
/// For [PageButtons].
class _IconButton extends StatelessWidget {
  const _IconButton({
    Key? key,
    required this.pageName,
    required this.icon,
  }) : super(key: key);

  final IconData icon;
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 0.774,
      child: IconFlatHexagonButton(
        onPressed: () => Navigator.of(context).pushReplacementNamed(pageName),
        //TODO tip
        tip: 'TODO',
        icon: icon,
        iconSize: screenAdjustNormalIconSize(context),
      ),
    );
  }
}
