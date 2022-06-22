import 'dart:async';
import 'package:localstore/localstore.dart';

// TaskList taskListFromJson(String str) => TaskList.fromJson(json.decode(str));

// String taskListToJson(TaskList data) => json.encode(data.toJson());

class Tasks {
  final String name;
  final List<dynamic> tasks;
  final bool status;
  final int  color;

  Tasks({
    required this.name, 
    required this.tasks, 
    required this.status,
    required this.color
  });

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'tasks': tasks,
      'status': status,
      'color': color
    };
  }

  factory Tasks.fromMap(Map<String,dynamic> map) {
    return Tasks(
      name: map['name'],
      tasks: map['tasks'],
      status: map['status'],
      color: map['color']
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
    final item = Tasks(name: name, tasks: tasks, status: status, color: color);
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

  Future removeTask(Map<String,bool> task) async {
    final _db = Localstore.instance;
    tasks.add(task);
    final item = Tasks(name: name, tasks: tasks, status: status, color: color);
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

  Future updateTask(int index, bool status, int color) async {
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
    final item = Tasks(name: name, tasks: tasks, status: done, color: color);
    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }

  Future updateColor(int color) async {
    final _db = Localstore.instance;


    var done = true;
    if (tasks.isEmpty) {
      done = false;
    } else {
      for(var task in tasks) {
        if(task.values.toList().first == false) {
          done = false;
          break;
        }
      }
    }
    final item = Tasks(name: name, tasks: tasks, status: done, color: color);

    return _db.collection('TaskLists').doc(name).set(item.toMap());
  }
}