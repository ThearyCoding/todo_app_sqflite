import 'package:sqflite/sqflite.dart';

const String tododb = "todo.db";
const String todoTable = 'todo';

class DatabaseHelper {
  DatabaseHelper._init();

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initializeDatabase();
    return _database;
  }

  Future<Database?> _initializeDatabase() async {
    final pathdatabase = await getDatabasesPath();

    final path = '$pathdatabase/$tododb';

    return openDatabase(path, version: 1, onCreate: _oncreateDatabase);
  }

  Future<void> _oncreateDatabase(Database db, int version) async {
    return await db.execute('''
    CREATE TABLE $todoTable (
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      isCompleted INTEGER NOT NULL,
      createdAt INTEGER NOT NULL
    );
    ''');
  }
}
