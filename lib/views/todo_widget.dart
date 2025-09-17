import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_list.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  const TodoWidget({super.key, required this.todo});

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        Provider.of<TodoList>(context, listen: false).remove(widget.todo);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.todo.name,
                      style: TextStyle(
                        decoration: widget.todo.complete
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: widget.todo.complete
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    Text(
                      widget.todo.description,
                      style: TextStyle(
                        decoration: widget.todo.complete
                            ? TextDecoration.lineThrough
                            : null,
                        color: widget.todo.complete ? Colors.grey : null,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: widget.todo.complete ? null : _updateTodo,
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: widget.todo.complete ? Colors.grey : Colors.blue,
                  ),
                ),
              ),
              Checkbox(
                activeColor: Colors.blueAccent,
                value: widget.todo.complete,
                onChanged: (bool? value) {
                  setState(() {
                    widget.todo.complete = value!;
                  });
                  Provider.of<TodoList>(context, listen: false).updateTodo(
                    widget.todo.copyWith(complete: value),
                  ); // Updates shared TodoList model.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTodo() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controlName = TextEditingController(
          text: widget.todo.name,
        );

        final TextEditingController controlDescription = TextEditingController(
          text: widget.todo.description,
        );

        return AlertDialog(
          actions: [
            Center(
              child: Consumer<TodoList>(
                builder: (context, todoModel, child) {
                  return ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      // Update shared model
                      todoModel.updateTodo(
                        Todo(
                          id: widget.todo.id,
                          name: controlName.text,
                          description: controlDescription.text,
                        ),
                      );

                      // Update UI
                      setState(() {
                        widget.todo.name = controlName.text;
                        widget.todo.description = controlDescription.text;
                      });

                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
                  );
                },
              ),
            ),
          ],
          content: Container(
            padding: const EdgeInsets.all(3),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Todo',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name of todo",
                      ),
                      controller: controlName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a todo name.";
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Description of todo",
                      ),
                      controller: controlDescription,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description.";
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
