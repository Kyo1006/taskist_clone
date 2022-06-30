import 'package:flutter/material.dart';

import '../app_screen/task_done.dart';
import '../app_screen/task_list.dart';
import '../app_screen/task_setting.dart';


class MenuBar extends StatefulWidget {
  const MenuBar({ Key? key ,required this.index }) : super(key: key);

  final int index;
  // final ThemeNotifier theme;
  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TaskDone(),
    TaskList(),
    TaskSetting()
  ];
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check, size: 30),
            label: 'Task done'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add, size: 30),
            label: 'Task list'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30),
            label: 'Setting'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF8e44ad),
        onTap: _onItemTapped,
      ),
    );
  }
}

