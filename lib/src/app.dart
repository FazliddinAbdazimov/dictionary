import 'package:flutter/material.dart';

import 'feature/search/ui/search_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  static run() => runApp(const App());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shaxsiy Lug`at',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
