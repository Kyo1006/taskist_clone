import 'package:flutter/material.dart';
import '../tasks.dart';

import 'package:localstore/localstore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EditTask extends StatefulWidget {
  const EditTask({Key? key, required this.item}) : super(key: key);

  final Tasks item;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _db = Localstore.instance;
  // final _items = <String,Tasks>{};
  // StreamSubscription<Map<String, dynamic>>? _subscription;

  double progress = 0;

  var myController = TextEditingController();

  @override
  void initState() {
    // _subscription = _db.collection('TaskLists').stream.listen((event) {
    // final item = Tasks.fromMap(event);
    // _items.putIfAbsent(item.name, () => item);
    pickerColor = Color(widget.item.color);
    currentColor = Color(widget.item.color);
    getProgress();
    // });
    // if (kIsWeb) _db.collection('TaskLists').stream.asBroadcastStream();

    super.initState();
  }

  // create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void getProgress() {
    setState(() {
      if (widget.item.tasks.isNotEmpty) {
        var countDone = widget.item.tasks
            .where((element) => element.values.toList().first)
            .toList()
            .length;
        progress = countDone / widget.item.tasks.length;
      } else {
        progress = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: colorPickerButton(),
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: cancelButton())
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Task list name
                          Text(widget.item.name,
                              style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          deleteTaskListButton()
                        ]),
                    progressBar(),
                    buildTaskList(),
                  ])),
        ),
        floatingActionButton: addTaskButton());
  }

  @override
  void dispose() {
    // _subscription?.cancel();
    super.dispose();
  }

  IconButton colorPickerButton() {
    return IconButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => showColorPicker()),
      icon: Icon(Icons.circle, color: currentColor, size: 36),
    );
  }

  IconButton cancelButton() {
    return IconButton(
        onPressed: () {
          setState(() {
            widget.item.updateColor(currentColor.value, _db);
          });
          Navigator.pop(context, 'Cancel');
        },
        icon: Icon(Icons.cancel_outlined, color: currentColor, size: 35));
  }

  IconButton deleteTaskListButton() {
    return IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Delete: ${widget.item.name}'),
                  content: const Text('Are you sure want to delete this list'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text('No'),
                      style: ElevatedButton.styleFrom(primary: currentColor),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        var nav = Navigator.of(context);
                        nav.pop();
                        nav.pop('Delete');
                      },
                      child: const Text('Yes'),
                      style: ElevatedButton.styleFrom(primary: currentColor),
                    )
                  ],
                )),
        icon: Icon(
          Icons.delete,
          color: currentColor,
          size: 40,
        ));
  }

  AlertDialog showColorPicker() {
    return AlertDialog(
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
    );
  }

  Row progressBar() {
    return Row(children: [
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
            child: Text('${(progress * 100).round()} %',
                style: const TextStyle(
                  fontSize: 14,
                ))),
      )
    ]);
  }

  Container buildTaskList() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 250,
      // height: 200,
      alignment: Alignment.topLeft,
      child: ListView.builder(
        itemCount: widget.item.tasks.length,
        itemBuilder: (BuildContext context, index) {
          return buildTask(widget.item.tasks[index], index);
        },
      ),
    );
  }

  void doNothing (BuildContext context) {}

  Widget buildTask(Map<String,dynamic> task, int index) {
    Color getColor(Set<MaterialState> states) {
      return currentColor;
    }
    final String taskName = task.keys.toList().first;
    final bool status = task.values.toList().first;

    return Slidable(
      endActionPane:  ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: '',
          ),
          SlidableAction(
            onPressed: (context) => setState(() {widget.item.removeTask(task, _db);}),
            backgroundColor: currentColor,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: status,
              onChanged: (bool? value) {
                widget.item.updateTask(
                    index,
                    !task.values.toList().first,
                    currentColor.value,
                    _db);
                getProgress();
              }),
          Text(taskName,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: task.values.toList().first
                      ? currentColor
                      : Colors.black,
                  decoration: task.values.toList().first
                      ? TextDecoration.lineThrough
                      : null)),
        ],
      ),
    );
  }

  FloatingActionButton addTaskButton() {
    return FloatingActionButton(
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
                      color: Color(0xFF7f8c8d)),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      widget.item.addTask({myController.text: false}, _db);
                      getProgress();
                      Navigator.pop(context, 'OK');
                      myController.clear();
                    },
                    child: const Text('Add'),
                    style: ElevatedButton.styleFrom(primary: currentColor),
                  )
                ],
              )),
      child: const Icon(Icons.add),
      backgroundColor: currentColor,
    );
  }
}
