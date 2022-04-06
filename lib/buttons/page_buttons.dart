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
        _NavigatorButton(
            pageName: 'Countdown',
            icon: Icons.timer_rounded,
            tip: 'Show the time left until the next launch.'),
        _NavigatorButton(
            pageName: 'Flights',
            icon: Icons.view_list_rounded,
            tip: 'Show all the upcoming launches.'),
        _NavigatorButton(
            pageName: 'Favorites',
            icon: Icons.favorite,
            tip: 'Show your bookmarked launches.'),
      ],
    );
  }
}

/// A button with an icon on it, that, when pressed
/// uses [Navigator] to replace the current page with the chosen one.
/// For [PageButtons].
class _NavigatorButton extends StatelessWidget {
  const _NavigatorButton({
    Key? key,
    required this.pageName,
    required this.icon,
    required this.tip,
  }) : super(key: key);

  final IconData icon;
  final String pageName, tip;

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 0.774,
      child: IconFlatHexagonButton(
        onPressed: () => Navigator.of(context).pushReplacementNamed(pageName),
        tip: tip,
        icon: icon,
        iconSize: screenAdjustNormalIconSize(context),
      ),
    );
  }
}
