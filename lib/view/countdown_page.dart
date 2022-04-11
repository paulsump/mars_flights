// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:mars_flights/view/retry_fetch.dart';
import 'package:share_plus/share_plus.dart';

/// The time until the next launch
class CountdownPage extends StatelessWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    final Flight? flight =
        fetchNotifier.hasFlight ? fetchNotifier.flight : null;

    final DateTime? date = flight?.date;

    return date != null
        ? Column(
            children: [
              Expanded(flex: isPortrait(context) ? 1 : 5, child: Container()),
              Expanded(
                  flex: isPortrait(context) ? 8 : 8, child: _Updater(date)),
              Expanded(
                flex: isPortrait(context) ? 2 : 8,
                child: const _ShareButton(),
              ),
            ],
          )
        : RetryFetch(message: fetchNotifier.flightErrorMessage);
  }
}

/// update the countdown every second.
class _Updater extends StatefulWidget {
  const _Updater(this.date, {Key? key}) : super(key: key);

  final DateTime date;

  @override
  State<_Updater> createState() => _UpdaterState();
}

class _UpdaterState extends State<_Updater> {
  late Timer timer;

  late DateTime _nowUtc;

  @override
  void initState() {
    _nowUtc = DateTime.now().toUtc();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _nowUtc = DateTime.now().toUtc();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Time(widget.date.difference(_nowUtc));
  }
}

/// Ui to display time / days left until launch
class _Time extends StatelessWidget {
  const _Time(this.duration, {Key? key}) : super(key: key);

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      _Number(label: 'DAYS', n: duration.inDays),
      _Number(label: 'HOURS', n: duration.inHours - duration.inDays * 24),
      _Number(label: 'MINUTES', n: duration.inMinutes.remainder(60)),
      _Number(label: 'SECONDS', n: duration.inSeconds.remainder(60)),
    ];

    return SizedBox(
      height: screenHeight(context) * (isPortrait(context) ? 0.68 : 0.35),
      child: isPortrait(context)
          ? Column(children: children)
          : SizedBox(
              width: screenAdjustX(0.7, context),
              child: Row(children: children),
            ),
    );
  }
}

/// A number and a label e.g. '5' 'days'.
class _Number extends StatelessWidget {
  const _Number({
    Key? key,
    required this.label,
    required this.n,
  }) : super(key: key);

  final String label;
  final int n;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Expanded(
            flex: 15,
            child: ScreenAdjustedText(n.toString(),
                size: isPortrait(context) ? 0.06 : 0.12)),
        Expanded(flex: 1, child: Container()),
        Expanded(
            flex: 10,
            child: ScreenAdjustedText(label,
                size: isPortrait(context) ? 0.02 : 0.04)),
      ]),
    );
  }
}

/// Buttons for social media platforms to share the next launch with friends.
class _ShareButton extends StatelessWidget {
  const _ShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    return !fetchNotifier.hasFlightMessage
        ? Container()
        : Padding(
          padding: EdgeInsets.all(screenAdjust(0.045, context)),
          child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: IconFlatHexagonButton(
                onPressed: () => _share(context,
                    subject: 'Launch Details',
                    message: fetchNotifier.flightMessage),
                icon: FontAwesomeIcons.share,
                tip:
                    "Open the device's share dialog to share details of this launch.",
              ),
            ),
        );
  }
}

/// Open the platform's share dialog with the provided subject and text.
void _share(BuildContext context,
    {required String subject, required String message}) async {
  // In the share_plus example (https://pub.dev/packages/share_plus/example),
  // a builder is used to retrieve the context immediately
  // surrounding the ElevatedButton.
  //
  // The context's `findRenderObject` returns the first
  // RenderObject in its descendant tree when it's not
  // a RenderObjectWidget. The ElevatedButton's RenderObject
  // has its position and size after it's built.
  final box = context.findRenderObject() as RenderBox?;

  await Share.share(message,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
}
