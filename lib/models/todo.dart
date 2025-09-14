// To-do model.
class Todo {
  late String id;
  late String name;
  late String description;
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