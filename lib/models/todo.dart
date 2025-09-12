class Todo {
  late String name;
  late String description;
  late bool complete;

  // Constructor
  Todo({ required this.name, required this.description, this.complete = false });

  @override
  String toString() {
    return "$name - ($description)";
  }
}