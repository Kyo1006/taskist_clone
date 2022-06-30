import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({ Key? key, required this.title }) : super(key: key);

  final String title;

  static const Map<int,String> weekDay = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday'
  };

  static const Map<int,String> months = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  DateTime now = DateTime.now();

  late DateTime date = DateTime(now.year,now.month,now.day);

  TextStyle dateStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 0, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text(Header.weekDay[date.weekday].toString(), style: dateStyle),
              Row(
                children: <Widget>[
                  Text(date.day.toString(), style: dateStyle),
                  Text(Header.months[date.month].toString(), style: dateStyle,),
                ],
              ),
            ],
          )
        ),
        Row(
          children: <Widget> [
            const Expanded(
              flex: 1,
              child: Divider(
                thickness: 1,
                color: Color(0xFF95a5a6),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  const Text('Task',style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  )),
                  Text(widget.title, style:  const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ))
                ]
              ),
            ),
            const Expanded(
              flex: 1,
              child: Divider(
                thickness: 1,
                color: Color(0xFF95a5a6),
              ),
            )
          ],
        )
      ],
    );
  }
}