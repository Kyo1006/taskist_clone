import 'package:flutter/material.dart';
import 'header.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';
import 'tasks.dart';
import 'edit_task.dart';
import 'menubar.dart';

class TaskDone extends StatefulWidget {
  const TaskDone({ Key? key }) : super(key: key);

  @override
  State<TaskDone> createState() => _TaskDoneState();
}

class _TaskDoneState extends State<TaskDone> {

  final _db = Localstore.instance;
  final _items = <String,Tasks>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  int count = 0;

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

  FutureOr onGoBack(dynamic resule, Tasks item) {
    if(resule) {
      setState(() {
        item.delete();
        _items.remove(item.name);
      });
    }
    else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return const MenuBar(index: 0);
        })
      );
    }
  }

  void navigateEditTask(item) {
    Route route = MaterialPageRoute(builder: (context) => EditTask(item: item));
    Navigator.push(context, route).then((value) => onGoBack(value, item));
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const Header(title: 'Done'),
            const SizedBox(
              height: 130,
            ),
            Container(
              height: 320,
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemCount: _items.keys.length,
                itemBuilder: (BuildContext context, index) {
                  final key = _items.keys.elementAt(index);
                  final item = _items[key]!;
                  if(item.status == false) {
                    return Container();
                  }
                  return InkWell(
                    onTap: () {
                      navigateEditTask(item);
                    },
                    child: Container(
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(item.color),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                            child: Text(item.name, style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ))
                          ),
                          const Divider(
                            indent: 50,
                            thickness: 3,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 180,
                            height: 200,
                            // margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                            child: Column(
                              children: item.tasks.map((task) {
                                return Row(
                                  children: <Widget> [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      shape: const CircleBorder(),
                                      // fillColor: MaterialStateProperty.resolveWith(getColor),
                                      activeColor: Color(item.color),
                                      value: task.values.toList().first, 
                                      onChanged: (bool? value) {}
                                    ),
                                    Text(
                                      task.keys.toList().first,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: task.values.toList().first ? const Color(0xFFf7f1e3): Colors.white,
                                        decoration: task.values.toList().first ? TextDecoration.lineThrough : null
                                      )
                                    ),
                                  ],
                                );
                              }).toList(),
                            )
                          )
                        ],
                      )
                    )
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }
}