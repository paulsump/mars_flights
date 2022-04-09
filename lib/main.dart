import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mars_flights/favorites_notifier.dart';
import 'package:mars_flights/fetch_notifier.dart';
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
              return const Scaffold(
                extendBody: true,
                bottomNavigationBar: _NavigationBar(),
                body: CountdownPage(),
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

class _NavigationBar extends StatefulWidget {
  static int _selectedIndex = 0;

  const _NavigationBar({Key? key}) : super(key: key);

  @override
  NavigationBarState createState() => NavigationBarState();
}

class NavigationBarState extends State<_NavigationBar> {
  void _onItemTapped(int index) {
    setState(() {
      _NavigationBar._selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 0,
        // to get rid of the shadow
        currentIndex: _NavigationBar._selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Level',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
