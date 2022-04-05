import 'package:flutter/material.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/view/countdown_page.dart';
import 'package:mars_flights/view/flights_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FetchNotifier()),
      ],
      child: MaterialApp(
        title: 'Mars Flights',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            if (constraints.maxHeight == 0) {
              return Container();
            } else {
              final fetchNotifier = getFetchNotifier(context, listen: false);

              if (!fetchNotifier.fetchAllHasBeenCalled) {
                // unawaited(fetchNotifier.fetchAll(context, _client));
              }

              return const CountdownPage();
            }
          },
        ),
        routes: {
          'Flights': (context) => const FlightsPage(),
        },
      ),
    );
  }
}

