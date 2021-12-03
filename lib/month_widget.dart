import 'package:app_control_gastos/wraph_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class month_widget extends StatefulWidget {
  final List<DocumentSnapshot>? documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;

  month_widget({Key? key, this.documents})
      : total =
            documents!.map((doc) => doc["value"]).fold(0.0, (a, b) => a + b),
        perDay = List.generate(30, (int index) {
          return documents
              .where((doc) => doc["day"] == (index + 1))
              .map((doc) => doc["value"])
              .fold(0.0, (a, b) => a + b);
        }),
        categories = documents.fold({}, (Map<String, double> map, document) {
          if (!map.containsKey(document['category'])) {
            map[document['category']] = 0.0;
          }
          if (document['value'] != null) {
            (map as dynamic)[document['category']] += (document['value']);
          }

          return map;
        }),
        super(key: key);

  @override
  _month_widgetState createState() => _month_widgetState();
}

class _month_widgetState extends State<month_widget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: <Widget>[
        _expenses(),
        _graph(),
        _list(context),
      ]),
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
        style: const TextStyle(
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
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
          )),
    );
  }

  Widget _list(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.categories.keys.length,
          itemBuilder: (BuildContext context, int index) {
            var key = widget.categories.keys.elementAt(index);
            var data = widget.categories[key];
            return Container(
              child:
                  _item(_loadIcon(key), key, 100 * data! ~/ widget.total, data),
              //FontAwesomeIcons.shoppingCart
              // _item(FontAwesomeIcons.wineGlass, "Alchol", 5, 73.57),
              // _item(FontAwesomeIcons.hamburger, "FastFood", 10, 101.34),
            );
          }),
    );
  }

  Widget _graph() {
    return Container(
        height: 250.0,
        child: GrapWidget(
          data: widget.perDay,
        ));
  }

  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text(
          "\$${widget.total.toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        const Text(
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
}

IconData _loadIcon(String key) {
  switch (key) {
    case "shopping":
      return FontAwesomeIcons.shoppingCart;
    case "entretenimiento":
      return FontAwesomeIcons.dice;
    case "bebida":
      return FontAwesomeIcons.wineGlass;
    case "comida":
      return FontAwesomeIcons.hamburger;
    case "boludeces":
      return FontAwesomeIcons.trash;
  }
  throw {};
}
