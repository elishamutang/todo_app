import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/todo_datasource.dart';
import 'package:get/get.dart';

// To-do List ViewModel.
class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [
    Todo(id: "1", name: "Shopping", description: "Pick up groceries"),
    Todo(id: "2", name: "Paint", description: "Recreate the Mona Lisa"),
    Todo(id: "3", name: "Dance", description: "I wanna dance with somebody")
  ];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  // Refresh todos
  Future<List<Todo>> refresh() async {
    IDataSource datasource = Get.find();
    removeAll();

    _todos.addAll(await datasource.browse());
    notifyListeners();
    return _todos;
  }

  // Add to-do
  void add(Todo todo) async {
    IDataSource datasource = Get.find();

    bool todoAdded = await datasource.add(todo);

    if (todoAdded) {
      _todos.add(todo);
      notifyListeners();
    }
  }

  // Remove all to-dos
  void removeAll() async {
    IDataSource datasource = Get.find();

    bool clearTodos = await datasource.clear();

    if (clearTodos) {
      _todos.clear();
      notifyListeners();
    }
  }

  // Remove a to-do
  void remove(Todo todo) async {
    IDataSource datasource = Get.find();

    bool removedTodo = await datasource.delete(todo);

    if (removedTodo) {
      _todos.remove(todo);
      notifyListeners();
    }
  }

  // Update existing to-do
  void updateTodo(Todo todo) async {
    IDataSource datasource = Get.find();

    bool updatedTodo = await datasource.edit(todo);

    if (updatedTodo) {
      Todo listTodo = _todos.firstWhere((t) => t.name == todo.name);
      listTodo = todo;
      notifyListeners();
    }
  }
}