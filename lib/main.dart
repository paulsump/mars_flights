import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mars_flights/favorites_notifier.dart';
import 'package:mars_flights/fetch_notifier.dart';
import 'package:mars_flights/hue.dart';
import 'package:mars_flights/view/background.dart';
import 'package:mars_flights/view/countdown_page.dart';
import 'package:mars_flights/view/flights_page.dart';
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
        ChangeNotifierProvider(create: (_) => _PageNotifier()),
      ],
      child: MaterialApp(
        title: 'SpaceX Launches',
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
                unawaited(fetchNotifier.fetchAll(context, _client));
              }

              final favoritesNotifier =
                  getFavoritesNotifier(context, listen: false);

              if (!favoritesNotifier.loadHasBeenCalled) {
                unawaited(favoritesNotifier.loadInitialValues());
              }
              return Scaffold(
                extendBody: true,
                bottomNavigationBar: const _NavigationBar(),
                body: _Pages(),
              );
            }
          },
        ),
        routes: {
          'Countdown': (context) => const CountdownPage(),
          'Flights': (context) => const FlightsPage(),
          'Favorites': (context) => const FavoritesPage(),
        },
      ),
    );
  }
}

class _PageNotifier extends ChangeNotifier {
  int _pageIndex = 0;

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}

class _Pages extends StatelessWidget {
  _Pages({Key? key}) : super(key: key);

  final _pages = <Widget>[
    const CountdownPage(),
    const FlightsPage(),
    const FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final pageNotifier = Provider.of<_PageNotifier>(context, listen: true);
    return _pages[pageNotifier._pageIndex];
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageNotifier = Provider.of<_PageNotifier>(context, listen: true);

    return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        currentIndex: pageNotifier._pageIndex,
        onTap: (index) => pageNotifier.setPageIndex(index),
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Hue.iconSelected,
        unselectedItemColor: Hue.iconDeselected,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconPair(selected: false),
            activeIcon: IconPair(selected: true),
            label: '',
          ),
        ]);
  }

// @override
// Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
