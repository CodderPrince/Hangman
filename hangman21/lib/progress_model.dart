class ProgressModel {
  final String userId;
  final String category;
  final int attempts;
  final String time;
  final bool isWin;

  ProgressModel({
    required this.userId,
    required this.category,
    required this.attempts,
    required this.time,
    required this.isWin,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'attempts': attempts,
      'time': time,
      'isWin': isWin,
    };
  }

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      userId: map['userId'],
      category: map['category'],
      attempts: map['attempts'],
      time: map['time'],
      isWin: map['isWin'],
    );
  }
}