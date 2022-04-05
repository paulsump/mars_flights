import 'package:flutter/material.dart';
import 'package:mars_flights/view/screen_adjusted_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mars Flights',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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
