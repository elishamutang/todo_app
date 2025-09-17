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
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: Icon(Icons.delete),
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
              Text(widget.todo.toString()),
              Checkbox(
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
}
