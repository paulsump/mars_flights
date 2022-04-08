import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars_flights/buttons/hexagon_button.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/out.dart';
import 'package:url_launcher/url_launcher.dart';

/// Add a share button for social media platforms to share the next launch with friends
class ShareButtons extends StatelessWidget {
  const ShareButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchNotifier = getFetchNotifier(context, listen: true);

    return !fetchNotifier.hasSocialMessage
        ? Container()
        : Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HexagonButton(
                  onPressed: () => unawaited(launch(
                    // 'TODO twitter URL + flight text',
                    // THIS works from a browser, but not from an app...
                    'http://twitter.com/home?status=This%20is%20an%20example',
                  )),
                  icon: FontAwesomeIcons.twitter,
                  color: const Color(0xFF1da1f2),
                  tip: 'Share this flight on Twitter',
                ),
                HexagonButton(
                  //TODO add flight info
                  onPressed: () =>
                      unawaited(_shareOnFacebook(fetchNotifier.socialMessage)),
                  icon: FontAwesomeIcons.facebookSquare,
                  color: const Color(0xFF0075FC),
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
      url: "https://www.apple.com",
      quote: message);

  out(result ?? 'facebook post failed');
}
