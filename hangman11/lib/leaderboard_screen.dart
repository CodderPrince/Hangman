import 'package:flutter/material.dart';
import 'progress_manager.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> leaderboardData = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    final data = await ProgressManager.loadProgress();
    setState(() {
      leaderboardData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: leaderboardData.isEmpty
          ? const Center(child: Text('No data available.'))
          : ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final entry = leaderboardData[index];
          return ListTile(
            title: Text("Name: ${entry['userName']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Category: ${entry['category']}"),
                Text("Attempts: ${entry['attempts']}"),
                Text("Time: ${entry['time']}"),
                Text("Win: ${entry['isWin']}"),
              ],
            ),
          );
        },
      ),
    );
  }
}