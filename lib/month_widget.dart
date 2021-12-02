import 'package:app_control_gastos/wraph_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class month_widget extends StatefulWidget {
  const month_widget
({ Key? key }) : super(key: key);

  @override
  _month_widgetState createState() => _month_widgetState();
}

class _month_widgetState extends State<month_widget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
  child: Column(
        children: <Widget>[
          _expenses(),
            _graph(),
            _list(),
        ]
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

}