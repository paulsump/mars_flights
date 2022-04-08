import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars_flights/buttons/hexagon_button.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/out.dart';

/// Add a share button for social media platforms to share the next launch with friends
class ShareButtons extends StatelessWidget {
  const ShareButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    return !fetchNotifier.hasFlightMessage
        ? Container()
        : Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HexagonButton(
                  onPressed: () =>
                      unawaited(_shareEmail(fetchNotifier.flightMessage)),
                  icon: Icons.email_rounded,
                  // color: const Color(0xFF1da1f2),
                  tip: 'Share this flight on email',
                ),
                HexagonButton(
                  onPressed: () =>
                      unawaited(_shareOnFacebook(fetchNotifier.flightMessage)),
                  icon: FontAwesomeIcons.facebookSquare,
                  // color: const Color(0xFF0075FC),
                  tip: 'Share this flight on Facebook',
                ),
              ],
            ),
          );
  }
}

Future<void> _shareOnFacebook(String message) async {
  String? result = await FlutterSocialContentShare.share(
      type: ShareType.facebookWithoutImage,
      url: 'https://www.spacex.com/',
      quote: message);

  out("Facebook: ${result ?? ' Post failed.'}");
}

Future<void> _shareEmail(String message) async {
  out('Email Message: $message');

  String? result = await FlutterSocialContentShare.shareOnEmail(
      // The recipient is ignored, but that is good because you want to choose who to send it to.
      // recipients: ['sumpner@hotmail.com'],
      subject: 'Mars Departure Date.',
      body: message);

  out("Email: ${result ?? ' Post failed.'}");
}
