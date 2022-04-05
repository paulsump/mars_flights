// © 2022, Paul Sumpner <sumpner@hotmail.com>
import 'package:flutter/material.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';

class CountdownPage extends StatelessWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildNumber(33, context),
            _buildText('DAYS', context),
            _buildNumber(33, context),
            _buildText('DAYS', context),
            _buildNumber(33, context),
            _buildText('DAYS', context),
            _buildNumber(33, context),
            _buildText('DAYS', context),
          ],
        ),
      ),
    );
  }

  Widget _buildNumber(int n, BuildContext context) {
    return Expanded(
        flex: 4, child: ScreenAdjustedText(n.toString(), size: 0.1));
  }

  Widget _buildText(String text, BuildContext context) {
    return Expanded(
      flex: 1,
      child: ScreenAdjustedText(text, size: 0.03),
    );
  }
}
