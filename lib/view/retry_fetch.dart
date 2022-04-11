import 'package:flutter/material.dart';
import 'package:mars_flights/buttons/flat_hexagon_button.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/screen_adjust.dart';

/// For when fetch fails, show an error message and a 'try again' button.
class RetryFetch extends StatelessWidget {
  const RetryFetch({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final textSize = isPortrait(context) ? 0.02 : 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAdjustX(0.1, context)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenAdjustX(isPortrait(context) ? 0.05 : 0.1, context),
          vertical: screenAdjustY(isPortrait(context) ? 0.22 : 0.1, context),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: ScreenAdjustedText(message, size: textSize),
              ),
              Expanded(
                flex: 2,
                child: ScreenAdjustedText('Try again?', size: textSize),
              ),
              Expanded(
                flex: 3,
                child: IconFlatHexagonButton(
                  icon: Icons.refresh_rounded,
                  tip: 'Fetch the data again',
                  onPressed: () => fetchAll(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
