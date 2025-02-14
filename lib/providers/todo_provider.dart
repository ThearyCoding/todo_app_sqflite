import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_sqflite/repository/todo_repo.dart';

import '../models/todo.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]) {
    fetchTodos();
  }

  final TodoRepo _todoRepo = TodoRepo();

  Future<void> fetchTodos() async {
    final todos = await _todoRepo.fetchTodos();

    state = todos;
  }

  Future<void> addTodo(Todo todo) async {
    await _todoRepo.addTodo(todo);
    fetchTodos();
  }

  Future<void> removeTodo(int id) async {
    await _todoRepo.removeTodo(id);
    fetchTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoRepo.updateTodo(todo);
    fetchTodos();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
