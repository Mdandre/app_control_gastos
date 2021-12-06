import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_control_gastos/wraph_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'month_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? _pageController;
  int currentPage = DateTime.now().month;
  late Stream<QuerySnapshot<Object?>> _query;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );

    _query = FirebaseFirestore.instance
        .collection('expenses')
        .where("month", isEqualTo: currentPage + 1)
        .snapshots();
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
                  print(_query);
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
    var _aligment;

    final selected = TextStyle(
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
      size: Size.fromHeight(70.0),
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
}

Future<void> _newDocument(BuildContext context) {
  var _category, _day, _month, _value;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Category:",
                    ),
                    //  obscureText: true,
                    controller: _category,
                    onSaved: (category) {
                      _category = category;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                GestureDetector(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Day:",
                    ),
                    // obscureText: true,
                    controller: _day,
                    onSaved: (day) {
                      _day = day;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                GestureDetector(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Month:",
                    ),
                    //obscureText: true,
                    controller: _month,
                    onSaved: (month) {
                      _month = month;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                GestureDetector(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Value:",
                    ),
                    //obscureText: true,
                    controller: _value,
                    onSaved: (value) {
                      _value = value;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(1.0),
                ),

                ///
                GestureDetector(
                    child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(3.0),
                      // side: BorderSide(width: 1, color: GenommaColor.blue),
                    ),
                    //    padding: EdgeInsets.fromLTRB(  35.0, _sizes.height * 0.015, 35.0, _sizes.height * 0.015),
                  ),
                  onPressed: () {
                    addGasto(_category, _day, _month, _value);
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

Future<void> addGasto(String category, int day, int month, double value) {
  CollectionReference gasto = FirebaseFirestore.instance.collection('expenses');
  return gasto
      .add({'category': category, 'day': day, 'month': month, 'value': value})
      .then((value) => print(" Added"))
      .catchError((error) => print("Failed to add : $error"));
}
