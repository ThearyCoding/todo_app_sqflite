import 'package:todo_app_sqflite/services/todo_service.dart';

import '../models/todo.dart';

class TodoRepo {
  final TodoService _todoService = TodoService.instance;

  Future<List<Todo>> fetchTodos() async {
    final todos = await _todoService.readAll();

    return todos!.map((todo) => Todo.fromJson(todo)).toList();
  }

  Future<void> addTodo(Todo todo) async {
    await _todoService.create(todo.toJson());
  }

  Future<void> removeTodo(int id) async {
    await _todoService.delete(id);
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoService.update(todo.id!, todo.toJson());
  }
}
