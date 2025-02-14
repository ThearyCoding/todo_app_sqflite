import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_sqflite/models/todo.dart';
import 'package:todo_app_sqflite/providers/todo_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _txttitle = TextEditingController();
  final TextEditingController _txtdescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todo = ref.watch(todoProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodo();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: todo.isEmpty
          ? const Center(
              child: Text('No have todo task'),
            )
          : ListView.builder(
              itemCount: todo.length,
              itemBuilder: (ctx, index) {
                final singleTodo = todo[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      addTodo(todo: singleTodo);
                    },
                    leading: Checkbox(
                      value: singleTodo.isCompleted,
                      onChanged: (value) {
                        final updatedTodo =
                            singleTodo.copy(isCompleted: value!);
                        ref.read(todoProvider.notifier).updateTodo(updatedTodo);
                      },
                    ),
                    title: Text(singleTodo.title),
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(todoProvider.notifier)
                            .removeTodo(singleTodo.id!);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void addTodo({Todo? todo}) {
    if (todo != null) {
      _txttitle.text = todo.title;
      _txtdescription.text = todo.description;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(todo != null ? 'Update Todo' : 'Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _txttitle,
                decoration:
                    const InputDecoration(hintText: 'Type todo task title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _txtdescription,
                decoration: const InputDecoration(
                    hintText: 'Type todo task description'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (todo != null) {
                    final updatedTodo = Todo(
                      id: todo.id,
                      isCompleted: todo.isCompleted,
                      title: _txttitle.text,
                      description: _txtdescription.text,
                    );
                    ref.read(todoProvider.notifier).updateTodo(updatedTodo);
                  } else {
                    final newTodo = Todo(
                      title: _txttitle.text,
                      description: _txtdescription.text,
                    );
                    ref.read(todoProvider.notifier).addTodo(newTodo);
                  }

                  _txttitle.clear();
                  _txtdescription.clear();
                  Navigator.pop(context);
                },
                child: Text(todo != null ? 'Update Todo' : 'Add Todo'),
              ),
            ],
          ),
        );
      },
    );
  }
}
