// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:app_control_gastos/home.dart' as home;

import 'package:flutter/material.dart';

class MonthList extends StatefulWidget {
  const MonthList({Key? key}) : super(key: key);

  @override
  State<MonthList> createState() => _MonthListState();
}

/// This is the private State class that goes with MonthList.
class _MonthListState extends State<MonthList> {
  int dropdownValue = 1;

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
          dropdownValue = newValue!;
          home.asignMonth(dropdownValue);
        });
      },
      items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
