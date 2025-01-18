import 'package:flutter/material.dart';
import 'hangman_game.dart';
import 'login_page.dart';

class HangmanApp extends StatelessWidget {
  final bool isLoggedIn;

  const HangmanApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? HangmanGame() : LoginPage(),
    );
  }
}