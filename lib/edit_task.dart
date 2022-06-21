import 'package:flutter/material.dart';
import 'tasks.dart';

import 'dart:async';
import 'package:localstore/localstore.dart';
import 'package:flutter/foundation.dart';

import 'add_task_dialog.dart';

class EditTask extends StatefulWidget {
  const EditTask({ Key? key, required this.item }) : super(key: key);
  
  final Tasks item;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _db = Localstore.instance;
  final _items = <String,Tasks>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  int count = 0;

  var myController = TextEditingController();

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
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(
                Icons.cancel_outlined, 
                color: Color(0xFF6933FF),
                size: 35
              )
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 20, 20, 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget> [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.item.name, style: const TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  )),
                  IconButton(
                    // onPressed: () {
                    //   widget.item.delete();
                    //   _items.remove(widget.item.name);
                    //   Navigator.pop(context);
                    // },
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Delete: ${widget.item.name}'),
                        content: const Text('Are you sure want to delete this list'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            }, 
                            child: const Text('No'),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF6933FF)
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              var nav = Navigator.of(context);
                              nav.pop();
                              nav.pop(true);
                            }, 
                            child: const Text('Yes'),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF6933FF)
                            ),
                          )
                        ],
                      )
                    ),
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xFF6933FF),
                      size: 40,
                    )
                  )
                ]
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 250,
                // height: 200,
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  itemCount: widget.item.tasks.length,
                  itemBuilder: (BuildContext context, index) {
                    Color getColor(Set<MaterialState> states) {
                      return const Color(0xFF6933FF);
                    }
                    return Row(
                      children: <Widget> [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: widget.item.tasks[index].values.toList().first, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.item.updateTask(index, !widget.item.tasks[index].values.toList().first);
                            });
                          }
                        ),
                        Text(
                          widget.item.tasks[index].keys.toList().first,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: widget.item.tasks[index].values.toList().first ? const Color(0xFF6933FF) : Colors.black,
                            decoration: widget.item.tasks[index].values.toList().first ? TextDecoration.lineThrough: null
                          )
                        ),
                      ],
                    );
                  }, 
                ),
              )
            ]
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AddTaskDialog(item: widget.item)
        ),
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF6933FF),
      ),
    );
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }
}