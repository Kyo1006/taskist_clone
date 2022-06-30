import 'package:flutter/material.dart';
import '../components/header.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';
import '../tasks.dart';
import 'edit_task.dart';

class TaskDone extends StatefulWidget {
  const TaskDone({Key? key}) : super(key: key);

  @override
  State<TaskDone> createState() => _TaskDoneState();
}

class _TaskDoneState extends State<TaskDone> {
  final _db = Localstore.instance;

  List<Tasks> taskLists = [];

  int count = 0;

  void getData() {
    _db.collection('TaskLists').get().then((value) {
      setState(() {        
        for(var key in value!.keys) {
          taskLists.add(Tasks.fromMap(value[key]));
        }
      });
    });
  }

  @override
  void initState() {
    getData();
    if (kIsWeb) _db.collection('TaskLists').stream.asBroadcastStream();
    super.initState();
  }

  

  FutureOr onGoBack(dynamic result, Tasks item) {
    if (result == 'Delete') {
      setState(() {
        item.delete(_db);
        taskLists.remove(item);
      });
    }
    else if (result == 'Cancel') {
      taskLists.clear();
      getData();
    }
  }

  void navigateEditTask(item) {
    Route route = MaterialPageRoute(builder: (context) => EditTask(item: item));
    Navigator.push(context, route).then((value) => onGoBack(value, item));
  }

  Container buildTaskLists() {
    return Container(
      height: 320,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemCount: taskLists.length,
        itemBuilder: (BuildContext context, index) {
          // final key = _items.keys.elementAt(index);
          // final item = _items[key]!;
          final item = taskLists[index];
          if (item.status == false) {
            return const SizedBox.shrink();
          }
          return taskListItem(item);
        },
      ),
    );
  }

  InkWell taskListItem(Tasks item) {
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Text(item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ))),
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
                          children: <Widget>[
                            Checkbox(
                                checkColor: Colors.white,
                                shape: const CircleBorder(),
                                // fillColor: MaterialStateProperty.resolveWith(getColor),
                                activeColor: Color(item.color),
                                value: task.values.toList().first,
                                onChanged: (bool? value) {}),
                            Text(task.keys.toList().first,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: task.values.toList().first
                                        ? const Color(0xFFf7f1e3)
                                        : Colors.white,
                                    decoration: task.values.toList().first
                                        ? TextDecoration.lineThrough
                                        : null)),
                          ],
                        );
                      }).toList(),
                    ))
              ],
            )));
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
          buildTaskLists(),
        ],
      )),
    );
  }
}
