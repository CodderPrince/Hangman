import 'package:flutter/material.dart';

import '../screen/login_screen.dart';
import '../screen/home_screen.dart';
import 'hangman_game.dart';

class HangmanApp extends StatelessWidget {
  final String initialRoute;

  const HangmanApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HangmanGame(),
      },
    );
  }
}
