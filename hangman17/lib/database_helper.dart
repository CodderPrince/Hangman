import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String userTable = 'users';


  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hangman_database.db');

    return await openDatabase(path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $userTable (
          userId TEXT PRIMARY KEY,
          userName TEXT,
          registrationDate TEXT
        )
    ''');
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(userTable, user.toMap());
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(userTable);
    return List.generate(maps.length, (index) => UserModel.fromMap(maps[index]));
  }
  Future<UserModel?> getUserById(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      userTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );
    if(maps.isNotEmpty){
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

}