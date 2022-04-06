// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';

class CountdownPage extends StatelessWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    final DateTime? time =
        fetchNotifier.hasFlight ? fetchNotifier.flight.time : null;

    return Scaffold(
      body: Center(
        child:
            time != null ? _Time(DateTime.now().difference(time)) : Container(),
      ),
    );
  }
}

/// Ui to display time / days left until launch
class _Time extends StatelessWidget {
  const _Time(this.duration, {Key? key}) : super(key: key);

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ..._buildNumber(33, 'DAYS', context),
        ..._buildNumber(33, 'DAYS', context),
        ..._buildNumber(33, 'DAYS', context),
        ..._buildNumber(33, 'DAYS', context),
      ],
    );
  }

  List<Widget> _buildNumber(int n, String label, BuildContext context) {
    return <Widget>[
      Expanded(flex: 4, child: ScreenAdjustedText(n.toString(), size: 0.1)),
      Expanded(flex: 1, child: ScreenAdjustedText(label, size: 0.03)),
    ];
  }
}
