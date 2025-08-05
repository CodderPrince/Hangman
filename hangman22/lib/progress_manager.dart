import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'progress_model.dart';

class ProgressManager {
  static const String _progressKey = 'userProgress';

  static Future<void> saveProgress(String userId, String category, int attempts, bool isWin) async {
    final prefs = await SharedPreferences.getInstance();
    List<ProgressModel> existingProgress = [];
    final existingData = prefs.getString(_progressKey);
    if (existingData != null) {
      try {
        final decodedData = jsonDecode(existingData) as List;
        existingProgress = decodedData.map((e) => ProgressModel.fromMap(e)).toList();
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    }

    existingProgress.add(ProgressModel(
      userId: userId,
      category: category,
      attempts: attempts,
      time: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      isWin: isWin,
    ));


    final jsonData = jsonEncode(existingProgress.map((e) => e.toMap()).toList());
    await prefs.setString(_progressKey, jsonData);
  }

  static Future<List<ProgressModel>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressString = prefs.getString(_progressKey);
    if (progressString != null) {
      try {
        final decodedData = jsonDecode(progressString) as List;
        return decodedData.map((e) => ProgressModel.fromMap(e)).toList();
      } catch (e) {
        print('Error decoding JSON: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
  }
}