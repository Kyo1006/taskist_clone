import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../tasks.dart';

class CreateList extends StatefulWidget {
  const CreateList({Key? key}) : super(key: key);

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {

  final myController = TextEditingController();

  // create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 250)).then((value) => {
      setState(() {
        focusNode.requestFocus();
      })
    });
    super.initState();
  }

  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'New List',
          ),
          centerTitle: true,
          elevation: 0,
          // backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        // backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Add the name of your list',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  // color: Color(0xFF95a5a6)
                )
              ),
              buildListNameInput(),
              colorPickerButton()
            ],
          ),
        ),
        floatingActionButton: createTaskListButton(),
        floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      ),
      onWillPop: _onWillPop  
    );
  }

  Future<bool> _onWillPop() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    return true;
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  TextField buildListNameInput() {
    return TextField(
      controller: myController,
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Your List...',
      ),
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      focusNode: focusNode,
    );
  }

  ElevatedButton colorPickerButton() {
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => showColorPicker()
      ),
      child: const SizedBox.shrink(),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), 
        primary: currentColor
      )
    );
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

  FloatingActionButton createTaskListButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        final item = Tasks(
            name: myController.text,
            tasks: [],
            status: false,
            color: currentColor.value);
        // item.save();
        // _items.putIfAbsent(item.name, () => item);
        _onWillPop();
        Navigator.pop(context, item);
      },
      label: const Text('Create Task', style: TextStyle(color: Colors.white)),
      icon: const Icon(Icons.add, color: Colors.white),
      backgroundColor: currentColor,
    );
  }
}
