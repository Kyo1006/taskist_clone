import 'package:flutter/material.dart';
import 'tasks.dart';

import 'dart:async';
import 'package:localstore/localstore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  double progress = 0;

  var myController = TextEditingController();

  @override
  void initState() {
    _subscription = _db.collection('TaskLists').stream.listen((event) {
      setState(() {
        final item = Tasks.fromMap(event);
        _items.putIfAbsent(item.name, () => item);
        pickerColor = Color(widget.item.color);
        currentColor = Color(widget.item.color);
        if (widget.item.tasks.isNotEmpty) {
          var countDone = widget.item.tasks.where((element) => element.values.toList().first).toList().length;
          progress = countDone / widget.item.tasks.length;
        }
        else {
          progress = 0;
        }
      });
    });
    if (kIsWeb) _db.collection('TaskLists').stream.asBroadcastStream();
    
    super.initState();
  }

  // create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
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
          icon: Icon(Icons.circle, color: currentColor, size: 36),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  widget.item.updateColor(currentColor.value);
                });
                Navigator.pop(context, false);
              },
              icon: Icon(
                Icons.cancel_outlined, 
                color: currentColor,
                size: 35
              )
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Delete: ${widget.item.name}'),
                        content: const Text('Are you sure want to delete this list'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            }, 
                            child: const Text('No'),
                            style: ElevatedButton.styleFrom(
                              primary: currentColor
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
                              primary: currentColor
                            ),
                          )
                        ],
                      )
                    ),
                    icon: Icon(
                      Icons.delete,
                      color: currentColor,
                      size: 40,
                    )
                  )
                ]
              ),
              Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      color: currentColor,
                      backgroundColor: const Color(0xFFecf0f1),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      alignment: Alignment.topRight,
                      child: Text(
                        '${(progress * 100).round()} %',
                        style: const TextStyle(
                          fontSize: 14,
                        )
                      )
                    ),
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
                      return currentColor;
                    }
                    return Row(
                      children: <Widget> [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: widget.item.tasks[index].values.toList().first, 
                          onChanged: (bool? value) {
                            setState(() {
                              widget.item.updateTask(
                                index, 
                                !widget.item.tasks[index].values.toList().first, 
                                currentColor.value
                              );
                            });
                          }
                        ),
                        Text(
                          widget.item.tasks[index].keys.toList().first,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: widget.item.tasks[index].values.toList().first ? currentColor : Colors.black,
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
          builder: (BuildContext context) => AlertDialog(
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
                  primary: currentColor
                ),
              )
            ],
          )
        ),
        child: const Icon(Icons.add),
        backgroundColor: currentColor,
      ),
    );
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }
}