import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'tasks.dart';

class CreateList extends StatefulWidget {
  const CreateList({ Key? key }) : super(key: key);

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final _db = Localstore.instance;
  final _items = <String,Tasks>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  final myController = TextEditingController();

  // create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    _subscription = _db.collection('TaskLists').stream.listen((event) {
      setState(() {
        final item = Tasks.fromMap(event);
        _items.putIfAbsent(item.name, () => item);
      });
    });
    if (kIsWeb) _db.collection('TaskLists').stream.asBroadcastStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New List', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            const Text('Add the name of your list', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF95a5a6)
            )),
            TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Your List...',
                hintStyle: TextStyle(
                  color: Color(0xFFbdc3c7)
                )
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xFF7f8c8d)
              ),
              autofocus: true,
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Select a color'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        setState(() => currentColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ), 
              child: const SizedBox.shrink(),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: currentColor
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final item = Tasks(name: myController.text, tasks: [], status: false, color: currentColor.value);
          item.save();
          _items.putIfAbsent(item.name, () => item);
          Navigator.pop(context);
        },
        label: const Text('Create Task'),
        icon: const Icon(Icons.add),
        backgroundColor: currentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,  
    );
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    myController.dispose();
    super.dispose();
  }
}