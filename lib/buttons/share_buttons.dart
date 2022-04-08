import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/screen_adjust.dart';
import 'package:url_launcher/url_launcher.dart';

/// Add a share button for social media platforms to share the next launch with friends
class ShareButtons extends StatelessWidget {
  const ShareButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _ShareButton(
            url: 'TODO facebook URL + flight text',
            icon: FontAwesomeIcons.facebookSquare,
            // color: Color(0xFF0075FC),
            tip: 'Share this flight on Facebook',
          ),
          _ShareButton(
            url: 'TODO twitter URL + flight text',
            icon: FontAwesomeIcons.twitter,
            // color: Color(0xFF1da1f2),
            tip: 'Share this flight on Twitter',
          ),
          _ShareButton(
            url: 'TODO linkedIn URL + flight text',
            icon: FontAwesomeIcons.linkedin,
            // color: Color(0xFF0072b1),
            tip: 'Share this flight on LinkedIn',
          )
        ],
      ),
    );
  }
}

/// A button with an icon on it, that, when pressed
/// uses [Navigator] to replace the current page with the chosen one.
/// For [PageButtons].
class _ShareButton extends StatelessWidget {
  const _ShareButton({
    Key? key,
    required this.url,
    required this.icon,
    required this.tip,
  }) : super(key: key);

  final IconData icon;
  final String url, tip;

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 1 + screenAdjustY(0.0003, context),
      child: IconFlatHexagonButton(
        onPressed: () => unawaited(launch(url)),
        tip: tip,
        icon: icon,
        iconSize: screenAdjustNormalIconSize(context),
      ),
    );
  }
}
