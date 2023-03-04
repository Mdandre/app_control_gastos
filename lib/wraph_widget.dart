import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class GrapWidget extends StatefulWidget {
  final List<double> data;
  final int month;

  const GrapWidget({Key? key, required this.data, required this.month}) : super(key: key);

  @override
  _GrapWidgetState createState() => _GrapWidgetState();
}

class _GrapWidgetState extends State<GrapWidget> {
  List<int> d31 = [1, 3, 5, 7, 8, 10, 12];
  List<int> d30 = [4, 6, 9, 11];
  int d28 = 2;

  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      for (var datumPair in selectedDatum) {
        measures[datumPair.series.displayName!] = datumPair.datum;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int days = 0;
    if (d31.contains(widget.month + 1)) {
      setState(() {
        days = 31;
      });
    } else if (d30.contains(widget.month + 1)) {
      setState(() {
        days = 30;
      });
    } else {
      setState(() {
        days = 28;
      });
    }
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Gasto',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index!,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];

    return LineChart(
      series,
      animate: false,
      selectionModels: [
        SelectionModelConfig(
          type: SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: NumericAxisSpec(
          //aca tendria que dividir el mes dependiedo cuantos dias tiene
          tickProviderSpec: StaticNumericTickProviderSpec([
        TickSpec(0, label: '01'),
        TickSpec(4, label: '05'),
        TickSpec(9, label: '10'),
        TickSpec(14, label: '15'),
        TickSpec(19, label: '20'),
        TickSpec(24, label: '25'),
        TickSpec(29, label: days.toString()),
      ])),
      primaryMeasureAxis: const NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
        desiredTickCount: 4, //aca seria el valor 1500 dividido 4
      )),
    );
  }
}
