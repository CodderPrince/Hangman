import 'package:flutter/material.dart';
import 'progress_manager.dart';
import 'package:intl/intl.dart';
import 'leaderboard_model.dart';
import 'database_helper.dart';
import 'dart:math';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardEntry> leaderboardData = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final _databaseHelper = DatabaseHelper();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      final progressData = await ProgressManager.loadProgress();
      final users = await _databaseHelper.getAllUsers();
      final leaderboardEntries = progressData.map((progress) {
        final user = users.firstWhere((element) => element.userId == progress.userId);
        return LeaderboardEntry(
          userName: user.userName,
          category: progress.category,
          attempts: progress.attempts,
          time:  progress.time,
          isWin: progress.isWin,
        );
      }).toList();
      leaderboardEntries.sort((a, b) {
        if (b.isWin && !a.isWin) {
          return 1;
        } else if (!b.isWin && a.isWin) {
          return -1;
        } else {
          return a.attempts.compareTo(b.attempts);
        }
      });
      setState(() {
        leaderboardData = leaderboardEntries;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load leaderboard Data";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(fontFamily: 'Arial Rounded MT Bold'),
        ),
        actions: [
          IconButton(
              onPressed: _clearLeaderboard,
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty ? Center(child: Text(_errorMessage)) :
      leaderboardData.isEmpty
          ? const Center(child: Text('No data available.'))
          : ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final entry = leaderboardData[index];
          final randomLightColor = Color.fromRGBO(
            _random.nextInt(156) + 100,
            _random.nextInt(156) + 100,
            _random.nextInt(156) + 100,
            1,
          );
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: randomLightColor,
            child: ListTile(
              title: Text(
                entry.userName,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontFamily: 'Arial Rounded MT Bold', // Apply font
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category: ${entry.category}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Arial Rounded MT Bold' // Apply font
                    ),
                  ),
                  Text(
                    "Attempts: ${entry.attempts}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Arial Rounded MT Bold', // Apply font
                    ),
                  ),
                  Text(
                    "Time: ${entry.time}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Arial Rounded MT Bold', // Apply font
                    ),
                  ),
                  Text(
                    "Win: ${entry.isWin}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Arial Rounded MT Bold', // Apply font
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _clearLeaderboard() async {
    await ProgressManager.clearProgress();
    _loadLeaderboardData();
  }
}