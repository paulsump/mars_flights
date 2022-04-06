// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/view/background.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';

class CountdownPage extends StatelessWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    final DateTime? time =
        fetchNotifier.hasFlight ? fetchNotifier.flight.time : null;

    // if (time != null) {
    //   out(time);
    // }

    return Background(
      child:
          time != null ? _Time(time.difference(DateTime.now())) : Container(),
    );
  }
}

/// Ui to display time / days left until launch
class _Time extends StatelessWidget {
  const _Time(this.duration, {Key? key}) : super(key: key);

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final days = duration.inDays;
    final hours = duration.inHours - duration.inDays * 24;

    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ..._buildNumber(days, 'DAYS', context),
        ..._buildNumber(hours, 'HOURS', context),
        ..._buildNumber(minutes, 'MINUTES', context),
        ..._buildNumber(seconds, 'SECONDS', context),
      ],
    );
  }

  List<Widget> _buildNumber(int n, String label, BuildContext context) {
    return <Widget>[
      Expanded(flex: 15, child: ScreenAdjustedText(n.toString(), size: 0.1)),
      Expanded(flex: 10, child: ScreenAdjustedText(label, size: 0.03)),
    ];
  }
}
