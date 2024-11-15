import 'package:todo_app_sqflite/services/database_helper.dart';

import '../models/todo.dart';

class TodoService {
  TodoService._init();

  static final TodoService instance = TodoService._init();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> close() async {
    final db = await dbHelper.database;

    db!.close();
  }

  Future<Todo> create(Todo todo) async {
    final db = await dbHelper.database;
    final id = await db?.insert(todoTable, todo.toJson());
    return todo.copy(id: id);
  }

  Future<List<Todo>> readAll() async {
    final db = await dbHelper.database;

    const orderBy = "createdAt DESC";

    final result = await db?.query(todoTable, orderBy: orderBy);

    return result!.map((todo) => Todo.fromJson(todo)).toList();
  }

  Future<int?> update(Todo todo) async {
    final db = await dbHelper.database;

    return await db?.update(todoTable, todo.toJson(),
        where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int?> delete(int id) async {
    final db = await dbHelper.database;

    return db?.delete(todoTable, where: 'id = ?', whereArgs: [id]);
  }
}
