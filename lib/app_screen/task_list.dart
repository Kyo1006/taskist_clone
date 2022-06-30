import 'package:flutter/material.dart';
import '../components/header.dart';
import 'create_list.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';
import '../tasks.dart';
import 'edit_task.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _db = Localstore.instance;

  late List<Tasks> taskLists = [];

  void getData() {
    _db.collection('TaskLists').get().then((value) {
      setState(() {
        for (var key in value!.keys) {
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

  FutureOr onGoBackFromEditTask(String result, Tasks item) {
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

  FutureOr onGoBackFromCreateList(Tasks item) {
    setState(() {
      item.save(_db);
      taskLists.add(item);
    });
  }

  void navigateEditTask(item) {
    Route route = MaterialPageRoute(builder: (context) => EditTask(item: item));
    Navigator.push(context, route).then((value) => onGoBackFromEditTask(value, item));
  }

  void navigateCreateList() {
    Route route = MaterialPageRoute(builder: (context) => const CreateList());
    Navigator.push(context, route).then((value) => onGoBackFromCreateList(value));
  }

  Padding addListButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
      child: SizedBox(
        width: 55,
        height: 55,
        child: OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ))),
            onPressed: navigateCreateList,
            child: const Icon(Icons.add)),
      ),
    );
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
          final item = taskLists[index];
          if (item.status == true) {
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
          const Header(title: 'List'),
          addListButton(),
          const Text('Add List'),
          buildTaskLists(),
        ],
      )),
    );
  }
}
