import 'package:flutter/material.dart';
import 'package:taskist/app_screen/edit_task.dart';
import '../tasks.dart';
import '../app_screen/edit_task.dart';

class Item extends StatefulWidget {
  const Item({ Key? key, required this.item }) : super(key: key);

  final Tasks item;

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return EditTask(item: widget.item);
          })
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFF6933FF),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Text(widget.item.name, style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ))
            ),
            const Divider(
              indent: 50,
              thickness: 3,
              color: Colors.white,
            )

          ],
        )
      )
    );
  }
}