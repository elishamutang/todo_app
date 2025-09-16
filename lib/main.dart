import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/services/SQLDatasource.dart';
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
  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();

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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Todo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                child: Text("Name"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                child: TextFormField(controller: _controlName),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                child: Text("Description"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                child: TextFormField(controller: _controlDescription),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Provider.of<TodoList>(context, listen: false).add(
                      Todo(
                        id: "0",
                        name: _controlName.text,
                        description: _controlDescription.text,
                      ),
                    ); // Updates shared TodoList model.
                    Navigator.pop(context);
                  });
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
