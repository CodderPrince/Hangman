class UserModel {
  String userId;
  String userName;
  DateTime registrationDate;


  UserModel({
    required this.userId,
    required this.userName,
    required this.registrationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      userName: map['userName'],
      registrationDate: DateTime.parse(map['registrationDate']),
    );
  }

}