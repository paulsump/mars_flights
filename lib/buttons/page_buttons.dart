// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/hexagon_button.dart';

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
      children: [
        HexagonButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('Countdown'),
            icon: Icons.timer_rounded,
            tip: 'Show the time left until the next launch.'),
        HexagonButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('Flights'),
            icon: Icons.view_list_rounded,
            tip: 'Show all the upcoming launches.'),
      ],
    );
  }
}
