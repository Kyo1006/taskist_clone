import 'dart:async';
import 'package:localstore/localstore.dart';

// TaskList taskListFromJson(String str) => TaskList.fromJson(json.decode(str));

// String taskListToJson(TaskList data) => json.encode(data.toJson());

class Tasks {
  final String name;
  final List<dynamic> tasks;
  final bool status;

  Tasks({required this.name, required this.tasks, required this.status});

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'tasks': tasks,
      'status': status
    };
  }

  factory Tasks.fromMap(Map<String,dynamic> map) {
    return Tasks(
      name: map['name'],
      tasks: map['tasks'],
      status: map['status']
    );
  }
}

extension ExtTasks on Tasks {
  Future save() async {
    final _db = Localstore.instance;
    return _db.collection('TaskLists').doc(name).set(toMap());
  }

  Future delete() async {
    final _db = Localstore.instance;
    return _db.collection('TaskLists').doc(name).delete();
  }

  Future addTask(Map<String,bool> task) async {
    final _db = Localstore.instance;
    tasks.add(task);
    final item = Tasks(name: name, tasks: tasks, status: status);
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

  Future updateTask(int index, bool status) async {
    final _db = Localstore.instance;
    String taskname = tasks[index].keys.toList().first;
    tasks[index][taskname] = status;
    var done = true;
    for(var task in tasks) {
      if(task.values.toList().first == false) {
        done = false;
        break;
      }
    }
    final item = Tasks(name: name, tasks: tasks, status: done);
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }
}