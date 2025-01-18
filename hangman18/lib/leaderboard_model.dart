class LeaderboardEntry {
  final String userName;
  final String category;
  final int attempts;
  final String time;
  final bool isWin;

  LeaderboardEntry({
    required this.userName,
    required this.category,
    required this.attempts,
    required this.time,
    required this.isWin,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      userName: map['userName'] ?? '',
      category: map['category'] ?? '',
      attempts: map['attempts'] ?? 0,
      time: map['time'] ?? '',
      isWin: map['isWin'] ?? false,
    );
  }
}