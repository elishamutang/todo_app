import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/services/SQLDatasource.dart';
import 'package:todo_list/services/remote_api_datasource.dart';
import 'package:todo_list/services/todo_datasource.dart';
import 'package:todo_list/views/todo_widget.dart';
import 'package:get/get.dart';
import 'package:todo_list/services/hive_datasource.dart';
import 'package:todo_list/models/todo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.putAsync<IDataSource>(() => HiveDatasource.createAsync()).whenComplete(
    () => runApp(
      ChangeNotifierProvider(
        create: (context) => TodoList(),
        child: const ToDoApp(),
      ),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const ToDoHomePage(), title: "To-Do App");
  }
}

class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({super.key});

  @override
  State<ToDoHomePage> createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();

  // Load todos from DB on mount.
  @override
  void initState() {
    super.initState();
    Provider.of<TodoList>(context, listen: false).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: [
          // Consumer widget listens for UI updates, in this case the change in number of incomplete todos.
          Consumer<TodoList>(
            builder: (context, model, child) {
              return Text(
                'Not completed: ${model.todos.where((t) => t.complete == false).length}',
                style: TextStyle(color: Colors.white),
              );
            },
          ),
          SizedBox(width: 10),
          Icon(Icons.menu),
          SizedBox(width: 10),
        ],
        backgroundColor: Colors.blueAccent,
        title: Text(
          "To-Do App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Consumer<TodoList>(
          builder: (context, model, child) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                itemCount: model.todoCount,
                itemBuilder: (context, index) {
                  return TodoWidget(todo: model.todos[index]);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: _openAddTodo,
        tooltip: 'Add new to-do',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _openAddTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Center(
              child: Consumer<TodoList>(
                builder: (context, todoModel, child) {
                  return ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      todoModel.add(
                        Todo(
                          id: UniqueKey().toString(),
                          name: _controlName.text,
                          description: _controlDescription.text,
                        ),
                      );

                      _controlName.clear();
                      _controlDescription.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  );
                },
              ),
            ),
          ],
          content: Container(
            padding: const EdgeInsets.all(3),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add New Todo',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name of todo",
                      ),
                      controller: _controlName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a todo name.";
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Description of todo",
                      ),
                      controller: _controlDescription,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description.";
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
