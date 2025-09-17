import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/todo_datasource.dart';
import 'package:get/get.dart';

// To-do List ViewModel.
class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  // Refresh todos
  Future<List<Todo>> refresh() async {
    IDataSource datasource = Get.find();
    _todos.clear();

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
