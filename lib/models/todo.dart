import 'package:hive/hive.dart';

// To-do model.
@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late bool complete;

  // Constructor
  Todo({ required this.id, required this.name, required this.description, this.complete = false });

  @override
  String toString() {
    return "$name - ($description)";
  }

  // Converts the model to Map<String, dynamic> that can map to SQL key-value pair.
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "complete": complete,
    };
  }

  // Converts model retrieved from SQL DB (which is a Map<String, dynamic>) into an object.
  factory Todo.fromMap(Map<String, dynamic> map) {
    // Assign from bool preferable
    bool? complete = map['complete'] is bool ? map['complete'] : null;

    // If null (failed to assign above), check if int and assign.
    // ??= - below means assign only if complete is null.
    complete ??= map['complete'] == 1 ? true : false;

    return Todo(
      id: map['id'].toString(),
      name: map['name'],
      description: map['description'],
      complete: map['complete'],
    );
  } 
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  Todo read(BinaryReader reader) {
    return Todo(
      id: reader.read(),
      name: reader.read(),
      description: reader.read(),
      complete: reader.read(),
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.complete);
  }
}