import 'package:flutter/material.dart';
import 'package:taskist/tasks.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({ Key? key, required this.item}) : super(key: key);

  final Tasks item;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: myController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Item',
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFF7f8c8d)
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.item.addTask({myController.text: false});
            Navigator.pop(context, 'OK');
          }, 
          child: const Text('Add'),
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF6933FF)
          ),
        )
      ],
    );
  }
}