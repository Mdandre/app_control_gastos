// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

import 'package:app_control_gastos/home.dart' as home;
import 'package:flutter/material.dart';

class categoriesList extends StatefulWidget {
  const categoriesList({Key? key}) : super(key: key);

  @override
  State<categoriesList> createState() => _categoriesListState();
}

/// This is the private State class that goes with categoriesList.
class _categoriesListState extends State<categoriesList> {
  String dropdownValue = 'shopping';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          home.asigncategory(dropdownValue);
        });
      },
      items: <String>["shopping", "boludeces", "entretenimiento"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
