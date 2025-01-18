import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hangman_app.dart';
import 'login_page.dart';
import 'hangman_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getString('userId') != null;
  String initialRoute = isLoggedIn ? HangmanGame.routeName : LoginPage.routeName;
  runApp(HangmanApp(initialRoute: initialRoute));
}