import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
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
        child: SingleChildScrollView(
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
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final item = Tasks(name: myController.text, tasks: [], status: false);
          item.save();
          _items.putIfAbsent(item.name, () => item);
          Navigator.pop(context);
        },
        label: const Text('Create Task'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF8e44ad),
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