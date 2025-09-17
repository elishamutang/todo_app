import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/todo_datasource.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatasource implements IDataSource {
  // Set up class and Hive
  Future initialise() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>('todos');
  }

  // Construct the HiveDatasource class pending the the completion of the intialise method.
  static Future<IDataSource> createAsync() async {
    HiveDatasource datasource = HiveDatasource();
    await datasource.initialise();
    return datasource;
  }

  // BREAD operations
  @override
  Future<List<Todo>> browse() async {
    Box<Todo> box = Hive.box('todos');
    print(box.values.toList());
    return box.values.toList();
  }

  // Add a new to-do
  @override
  Future<bool> add(Todo todo) async {
    Box<Todo> box = Hive.box('todos');
    box.put(todo.id, todo);
    return true;
  }

  // Delete a to-do
  @override
  Future<bool> delete(Todo todo) async {
    Box<Todo> box = Hive.box('todos');
    box.delete(todo.id);
    return true;
  }

  // Read a to-do
  @override
  Future<Todo?> read(String id) async {
    Box<Todo> box = Hive.box('todos');
    return box.get(id);
  }

  // Edit a to-do
  @override
  Future<bool> edit(Todo todo) async {
    Box<Todo> box = Hive.box('todos');
    box.put(todo.id, todo);
    return true;
  }

  // Clear all data
  @override
  Future<bool> clear() async {
    Box<Todo> box = Hive.box('todos');
    box.clear();
    return true;
  }
}
