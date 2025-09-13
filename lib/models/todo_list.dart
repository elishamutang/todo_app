import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:todo_list/models/todo.dart';

// To-do List ViewModel.
class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [
    Todo(name: "Shopping", description: "Pick up groceries"),
    Todo(name: "Paint", description: "Recreate the Mona Lisa"),
    Todo(name: "Dance", description: "I wanna dance with somebody")
  ];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  // Add to-do
  void add(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  // Remove all to-dos
  void removeAll() {
    _todos.clear();
    notifyListeners();
  }

  // Remove a to-do
  void remove(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  // Update existing to-do
  void updateTodo(Todo todo) {
    Todo listTodo = _todos.firstWhere((t) => t.name == todo.name);
    listTodo = todo;
    notifyListeners();
  }
}