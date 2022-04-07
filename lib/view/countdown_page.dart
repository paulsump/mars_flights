// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/background.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';

class CountdownPage extends StatelessWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    final Flight? flight =
        fetchNotifier.hasFlight ? fetchNotifier.flight : null;

    final DateTime? date = flight?.date;

    // if (flight != null) {
    // out(flight.id!);
    // out(flight.launchPad!);
    // }

    return Background(
      child: date != null
          ? _Time(
              date.difference(DateTime.now()),
            )
          : Center(child: ScreenAdjustedText(fetchNotifier.flightErrorMessage)),
    );
  }
}

/// Ui to display time / days left until launch
class _Time extends StatelessWidget {
  const _Time(this.duration, {Key? key}) : super(key: key);

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      _buildNumber('DAYS', duration.inDays, context),
      _buildNumber('HOURS', duration.inHours - duration.inDays * 24, context),
      _buildNumber('MINUTES', duration.inMinutes.remainder(60), context),
      _buildNumber('SECONDS', duration.inSeconds.remainder(60), context),
    ];

    return SizedBox(
      height: screenHeight(context) * (isPortrait(context) ? 0.68 : 0.35),
      child: isPortrait(context)
          ? Column(children: children)
          : Row(children: children),
    );
  }

  Widget _buildNumber(String label, int n, BuildContext context) {
    return Expanded(
      child: Column(children: [
        Expanded(
            flex: 15,
            child: ScreenAdjustedText(n.toString(),
                size: isPortrait(context) ? 0.07 : 0.12)),
        Expanded(
            flex: 10,
            child: ScreenAdjustedText(label,
                size: isPortrait(context) ? 0.02 : 0.04)),
      ]),
    );
  }
}
