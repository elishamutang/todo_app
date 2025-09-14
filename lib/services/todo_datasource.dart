import 'package:todo_list/models/todo.dart';

//  Abstract class IDataSource defines what operations can be done instead of how they are implemented.
//  It essentially de-couples the app's business logic and UI from the details of the datasource.

abstract class IDataSource {
  Future<List<Todo>> browse();
  Future<bool> add(Todo model);
  Future<bool> delete(Todo model);
  Future<Todo?> read(String id);
  Future<bool> edit(Todo model);
  Future<bool> clear();
}