import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mars_flights/favorites_notifier.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/view/background.dart';
import 'package:provider/provider.dart';

/// The main entry point for the flutter app
void main() => runApp(createApp(client: http.Client()));

/// Create the app instance (uses in tests too)
/// This function allows the app to be private so that I can call it what I like.
Widget createApp({required http.Client client}) => _App(client: client);

/// The only app.  Has all the notifiers and navigator routes.
/// Calls fetchAll() once on the FetchNotifier.
class _App extends StatelessWidget {
  const _App({Key? key, required http.Client client})
      : _client = client,
        super(key: key);

  final http.Client _client;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FetchNotifier()),
        ChangeNotifierProvider(create: (_) => FavoritesNotifier()),
        ChangeNotifierProvider(create: (_) => PageNotifier()),
      ],
      child: MaterialApp(
        title: 'SpaceX Launches',
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
                unawaited(fetchNotifier.fetchAll(context, _client));
              }

              final favoritesNotifier =
                  getFavoritesNotifier(context, listen: false);

              if (!favoritesNotifier.loadHasBeenCalled) {
                unawaited(favoritesNotifier.loadInitialValues());
              }

              return const Background();
            }
          },
        ),
      ),
    );
  }
}

