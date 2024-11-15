import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/models/todo.dart';
import 'package:todo_app_sqflite/services/todo_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Todo> _todos = [];
  final TextEditingController _txttitle = TextEditingController();
  final TextEditingController _txtdescription = TextEditingController();
  final TodoService _todoService = TodoService.instance;
  @override
  void initState() {
    refreshTodo();
    super.initState();
  }

  refreshTodo() {
    _todos.clear();
    _todoService.readAll().then((todos) {
      setState(() {
        _todos.addAll(todos);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: _todos.isEmpty
            ? const Center(
                child: Text('No have todo task'),
              )
            : ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (ctx, index) {
                  final todo = _todos[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        addTodo(todo: todo);
                      },
                      leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (value) async {
                            setState(() {
                              todo.isCompleted = value!;
                            });
                            await _todoService.update(todo);
                          }),
                      title: Text(todo.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  _todos.removeAt(index);
                                });
                                await _todoService.delete(todo.id!);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    ),
                  );
                }));
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
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _txtdescription,
                  decoration: const InputDecoration(
                      hintText: 'Type todo task description'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (todo != null) {
                        await _todoService.update(Todo(
                            id: todo.id,
                            isCompleted: todo.isCompleted,
                            title: _txttitle.text,
                            description: _txtdescription.text));
                      } else {
                        await _todoService.create(Todo(
                            title: _txttitle.text,
                            description: _txtdescription.text));
                      }

                      refreshTodo();
                      if (!mounted) return;
                      _txttitle.clear();
                      _txtdescription.clear();
                      Navigator.pop(context);
                    },
                    child: Text(todo != null ? 'Update Todo' : 'Add Todo'))
              ],
            ),
          );
        });
  }
}
