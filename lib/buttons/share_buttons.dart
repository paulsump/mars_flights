import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Add a share button for social media platforms to share the next launch with friends
class ShareButtons extends StatelessWidget {
  const ShareButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialButton(
              icon: FontAwesomeIcons.facebookSquare,
              color: const Color(0xFF0075FC),
              onClicked: () => share(SocialMedia.facebook),
            ),
            buildSocialButton(
              icon: FontAwesomeIcons.twitter,
              color: const Color(0xFF1da1f2),
              onClicked: () => share(SocialMedia.twitter),
            ),
            buildSocialButton(
              icon: FontAwesomeIcons.linkedin,
              color: const Color(0xFF0072b1),
              onClicked: () => share(SocialMedia.linkedIn),
            )
          ],
        ),
      ),
    );
  }
}

Future share(SocialMedia platform) async {
  final urls = {
    SocialMedia.facebook: ('face book shareable link'),
    SocialMedia.twitter: ('twitter shareable link'),
    SocialMedia.linkedIn: ('linkedIn link')
  };
  final url = urls[platform]!;
  await launch(url);
}

enum SocialMedia { facebook, twitter, linkedIn }

Widget buildSocialButton(
        {required IconData icon,
        Color? color,
        required Function() onClicked}) =>
    InkWell(
      child: SizedBox(
        width: 60,
        height: 60,
        child: Center(child: Icon(icon, color: color, size: 40)),
      ),
      onTap: onClicked,
    );
