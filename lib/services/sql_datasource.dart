import 'package:todo_list/services/todo_datasource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list/models/todo.dart';

class SQLDatasource implements IDataSource {
  late Database _database;

  Future initialise() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_data.db'),
      version: 5,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)',
        );
      },
    );
  }

  static Future<IDataSource> createAsync() async {
    SQLDatasource datasource = SQLDatasource();
    await datasource.initialise();
    return datasource;
  }

  // BREAD operations
  // Browse todos
  @override
  Future<List<Todo>> browse() async {
    await initialise();

    List<Map<String, dynamic>> todos = await _database.query('todos');

    return List.generate(todos.length, (index) {
      return Todo.fromMap(todos[index]);
    });
  }

  // Add new todo
  @override
  Future<bool> add(Todo todo) async {
    try {
      await initialise();

      // Remove ID field in todoMap because ID will be created automatically by SQLite.
      Map<String, dynamic> todoMap = todo.toMap();
      todoMap.remove('id');
      todoMap['complete'] = todoMap['complete'] == true ? 1 : 0;

      final int newTodos = await _database.insert('todos', todoMap);
      return newTodos > 0;
    } catch (e) {
      print('Adding todo failed: $e');
      return false;
    }
  }

  // Delete a todo
  @override
  Future<bool> delete(Todo todo) async {
    try {
      await initialise();

      final int deletedTodos = await _database.delete(
        'todos',
        where: 'id = ?',
        whereArgs: [todo.id],
      );
      return deletedTodos > 0;
    } catch (e) {
      print('Delete failed: $e');
      return false;
    }
  }

  // Read a todo
  @override
  Future<Todo?> read(String id) async {
    try {
      await initialise();

      List<Map<String, dynamic>> chosenTodo = await _database.query(
        'todos',
        where: 'id = ?',
        whereArgs: [id],
      );
      return Todo.fromMap(chosenTodo[0]);
    } catch (e) {
      print('Read failed: $e');
      return null;
    }
  }

  // Edit a todo
  @override
  Future<bool> edit(Todo todo) async {
    try {
      await initialise();

      Map<String, dynamic> todoMap = todo.toMap();
      todoMap['complete'] = todoMap['complete'] == true ? 1 : 0;

      final int editedTodos = await _database.update(
        'todos',
        todoMap,
        where: 'id = ?',
        whereArgs: [todoMap['id']],
      );
      return editedTodos > 0;
    } catch (e) {
      print('Edit failed: $e');
      return false;
    }
  }

  // Clear all todos
  @override
  Future<bool> clear() async {
    try {
      await initialise();

      final int deletedTodos = await _database.delete('todos');
      return deletedTodos > 0;
    } catch (e) {
      print('Clear failed: $e');
      return false;
    }
  }
}
