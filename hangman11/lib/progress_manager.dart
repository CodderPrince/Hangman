import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static const String _progressKey = 'userProgress';

  static Future<void> saveProgress(String userName, String category, int attempts, bool isWin) async {
    final prefs = await SharedPreferences.getInstance();
    List<dynamic> existingProgress = [];
    final existingData = prefs.getString(_progressKey);
    if (existingData != null) {
      existingProgress = jsonDecode(existingData);
    }
    existingProgress.add({
      'userName': userName,
      'category': category,
      'attempts': attempts,
      'time': DateTime.now().toString(),
      'isWin': isWin,
    });
    final jsonData = jsonEncode(existingProgress);
    await prefs.setString(_progressKey, jsonData);
  }

  static Future<List<dynamic>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressString = prefs.getString(_progressKey);
    if (progressString != null) {
      return jsonDecode(progressString);
    } else {
      return [];
    }
  }

  static Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
  }
}