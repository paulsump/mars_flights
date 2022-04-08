import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars_flights/buttons/hexagon_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Add a share button for social media platforms to share the next launch with friends
class ShareButtons extends StatelessWidget {
  const ShareButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HexagonButton(
            onPressed: () => unawaited(launch(
              'TODO twitter URL + flight text',
            )),
            icon: FontAwesomeIcons.twitter,
            color: const Color(0xFF1da1f2),
            tip: 'Share this flight on Twitter',
          ),
          HexagonButton(
            onPressed: () => unawaited(launch(
              'TODO facebook URL + flight text',
            )),
            icon: FontAwesomeIcons.facebookSquare,
            color: const Color(0xFF0075FC),
            tip: 'Share this flight on Facebook',
          ),
        ],
      ),
    );
  }
}
