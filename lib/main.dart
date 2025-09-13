import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/views/todo_widget.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TodoList(),
    child: const ToDoApp(),
  ));
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ToDoHomePage(),
      title: "To-Do App",
    );
  }
}

class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({super.key});

  @override
  State<ToDoHomePage> createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          // Consumer widget listens for UI updates, in this case the change in number of incomplete todos.
          Consumer<TodoList>(builder: (context, model, child) {
            return Text(
              'Not completed: ${model.todos.where((t) => t.complete == false).length}',
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }),
          SizedBox(width: 10),
          Icon(Icons.menu),
          SizedBox(width: 10)
        ],
        backgroundColor: Colors.blueAccent,
        title: Text(
          "To-Do App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Consumer<TodoList>(builder: (context, model, child) {
          return ListView.builder(
            itemCount: model.todoCount,
            itemBuilder: (context, index) {
              return TodoWidget(todo: model.todos[index]);
            },
          );
        }),
      ),
    );
  }
}




