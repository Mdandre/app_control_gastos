import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'categories_list.dart';
import 'day_list.dart';
import 'month_list.dart';
import 'month_widget.dart';

var _category = 'shopping', _day = 1, _month = 1;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? _pageController;
  int currentPage = DateTime.now().month;
  late Stream<QuerySnapshot<Object?>> _query;
  late TextEditingController
      valueExp; //Pueder servir para el controler del valor del gasto

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
    valueExp = TextEditingController();
    _query = FirebaseFirestore.instance
        .collection('expenses')
        .where("month", isEqualTo: currentPage + 1)
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    valueExp.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _bottomAction(IconData icon) {
      return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon),
        ),
        onTap: () {},
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAction(FontAwesomeIcons.history),
            _bottomAction(FontAwesomeIcons.chartPie),
            SizedBox(
              width: 48.0,
            ),
            _bottomAction(FontAwesomeIcons.wallet),
            _bottomAction(Icons.settings),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _newDocument(context);
        },
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
              stream: _query,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                if (data.hasData) {
                  return month_widget(
                    documents: data.data!.docs.toList(),
                    month: currentPage,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    Alignment _aligment;

    const selected = TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blueGrey);

    final unselected = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Colors.blueGrey.withOpacity(0.4));

    if (position == currentPage) {
      _aligment = Alignment.center;
    } else if (position > currentPage) {
      _aligment = Alignment.centerRight;
    } else {
      _aligment = Alignment.centerLeft;
    }

    return Align(
        alignment: _aligment,
        child: Text(
          name,
          style: position == currentPage ? selected : unselected,
        ));
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: const Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;
            _query = FirebaseFirestore.instance
                .collection('expenses')
                .where("month", isEqualTo: currentPage + 1)
                .snapshots();
          });
        },
        controller: _pageController,
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }

  Future<void> _newDocument(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text("Category"),
                  GestureDetector(
                    child: const categoriesList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  const Text("Month"),
                  GestureDetector(
                    child: const monthList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  const Text("Day"),
                  GestureDetector(
                    child: dayList(
                      month: _month,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  GestureDetector(
                      child: TextFormField(
                          controller: valueExp,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Value',
                          ),
                          validator: (value) {
                             if (valueExp is String) {
                              return "Ingrese un valor numerico";
                            }
                          })),
                  const Padding(
                    padding: EdgeInsets.all(1.0),
                  ),

                  ///
                  GestureDetector(
                      child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                        // side: BorderSide(width: 1, color: GenommaColor.blue),
                      ),
                      //    padding: EdgeInsets.fromLTRB(  35.0, _sizes.height * 0.015, 35.0, _sizes.height * 0.015),
                    ),
                    onPressed: () {
                      addGasto(
                          _category, _day, _month, double.parse(valueExp.text));
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Agregar",
                      textAlign: TextAlign.center,
                      // style: TextStyleExtension.roboto( color: GenommaColor.blue, weight: FontWeight.w600)),
                    ),
                  ))

                  ///
                ],
              ),
            ),
            //--,
          );
        });
  }

  Future<void> addGasto(String? category, int day, int month, double value) {
    CollectionReference gasto =
        FirebaseFirestore.instance.collection('expenses');
    return gasto
        .add({'category': category, 'day': day, 'month': month, 'value': value})
        .then((value) => print(" Added"))
        .catchError((error) => print("Failed to add : $error"));
  }
}

void asignDay(int dropdownValue) {
  _day = dropdownValue;
}

void asignMonth(int dropdownValue) {
  _month = dropdownValue;
}

void asigncategory(String dropdownValue) {
  _category = dropdownValue;
}
