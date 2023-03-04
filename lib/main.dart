import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/wraph_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
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
  int currentPage = 9;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );

    // FirebaseFirestore.instance
    //     .collection('expenses')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc);
    //   });
    // });
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
        onPressed: () {},
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          _expenses(),
          _graph(),
          _list(),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      leading: Icon(
        icon,
        size: 32.0,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
      ),
      subtitle: Text("$percent% of expenses"),
      trailing: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "\$$value",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
          )),
    );
  }

  Widget _list() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
          _item(FontAwesomeIcons.wineGlass, "Alchol", 5, 73.57),
          _item(FontAwesomeIcons.hamburger, "FastFood", 10, 101.34),
        ],
      ),
    );
  }

  Widget _graph() {
    return Container(height: 250.0, child: GrapWidget());
  }

  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text(
          "\$2361",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        Text(
          "Total Expenses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.00,
            color: Colors.blueGrey,
          ),
        )
      ],
    );
  }

  Widget _pageItem(String name, int position) {
    var _aligment;

    final selected = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blueGrey);

    final unselected =
        TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.blueGrey.withOpacity(0.4));

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
