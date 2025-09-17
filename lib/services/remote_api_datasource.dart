// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_list/firebase_options.dart';

// Todo Datasource imports
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/todo_datasource.dart';

class RemoteApiDatasource implements IDataSource {
  late FirebaseDatabase database;

  // Initialise the database
  Future initialise() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    database = FirebaseDatabase.instance;
  }

  // Creates an instance of the RemoteApiDatasource class, initialises the Firebase DB and returns it.
  static Future<RemoteApiDatasource> createAsync() async {
    RemoteApiDatasource datasource = RemoteApiDatasource();
    await datasource.initialise();
    return datasource;
  }

  // BREAD operations
  // Browse todos
  @override
  Future<List<Todo>> browse() async {
    final DataSnapshot snapshot = await database.ref('todos').get();

    if (!snapshot.exists) {
      throw Exception(
        'Invalid request - Cannot find snapshot: ${snapshot.ref.path}',
      );
    }

    // Creates list of todos from Firebase DB.
    List<Todo> todos = <Todo>[];

    (snapshot.value as Map).values
        .map((e) => Map<String, dynamic>.from(e))
        .forEach((element) => todos.add(Todo.fromMap(element)));

    return todos;
  }

  // Add a new to-do
  @override
  Future<bool> add(Todo todo) async {
    DatabaseReference todosRef = database.ref('todos');

    // Generate unique key for new todo and set it to todo.id
    DatabaseReference newTodoRef = todosRef.push();
    todo.id = newTodoRef.key as String;

    final bool result = await newTodoRef
        .set(todo.toMap())
        .then((_) {
          print("Todo added succesfully");
          return true;
        })
        .catchError((error) {
          print("Adding todo failed: $error");
          return false;
        });

    return result;
  }

  // Delete a to-do
  @override
  Future<bool> delete(Todo todo) async {
    DatabaseReference todoRef = database.ref('todos/${todo.id}');

    try {
      await todoRef.remove();
      return true;
    } catch (e) {
      print('Delete failed: $e');
      return false;
    }
  }

  // Read a to-do
  @override
  Future<Todo?> read(String id) async {
    final DataSnapshot todoSnapshot = await database.ref('todos/$id').get();

    if (!todoSnapshot.exists) {
      throw Exception(
        'Invalid request - Cannot find snapshot: ${todoSnapshot.ref.path}',
      );
    }

    Map<String, dynamic> todo = Map<String, dynamic>.from(
      todoSnapshot.value as Map,
    );

    return Todo.fromMap(todo);
  }

  // Edit a to-do
  @override
  Future<bool> edit(Todo todo) async {
    DatabaseReference todoRef = database.ref('todos/${todo.id}');

    try {
      await todoRef.set(todo.toMap());
      return true;
    } catch (e) {
      print('Update failed: $e');
      return false;
    }
  }

  // Clear to-dos
  @override
  Future<bool> clear() async {
    DatabaseReference todosRef = database.ref('todos');

    try {
      await todosRef.remove();
      return true;
    } catch (e) {
      print('Clear failed: $e');
      return false;
    }
  }
}
