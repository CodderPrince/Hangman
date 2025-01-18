import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hangman_app.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getString('userName') != null;
  runApp(HangmanApp(isLoggedIn: isLoggedIn));
}