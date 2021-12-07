// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:app_control_gastos/home.dart' as home;
import 'package:flutter/material.dart';

class dayList extends StatefulWidget {
  final int month;
  const dayList({Key? key, required this.month}) : super(key: key);

  @override
  State<dayList> createState() => _dayListState();
}

/// This is the private State class that goes with dayList.
class _dayListState extends State<dayList> {
  int dropdownValue = 1;
  List<int> d31 = [1, 3, 5, 7, 8, 10, 12];
  List<int> d30 = [4, 6, 9, 11];
  int d28 = 2;
  late List<int> days;
  @override
  void initState() {
    super.initState();
    if (d31.contains(widget.month)) {
      days = List<int>.generate(31, (i) => i);
    } else if (d30.contains(widget.month)) {
      days = List<int>.generate(30, (i) => i);
    } else {
      days = List<int>.generate(28, (i) => i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (int? newValue) {
        setState(() {
          dropdownValue = (newValue!);
          home.asignDay(dropdownValue);
        });
      },
      items: days.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
