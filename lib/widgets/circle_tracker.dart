import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:caphe_0/widgets/legend.dart';

class CircleTracker extends StatefulWidget {
  @override
  _CircleTrackerState createState() => _CircleTrackerState();
}

class _CircleTrackerState extends State<CircleTracker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Stack(
                children: <Widget>[
                  Center(child:GaugeChart(GaugeChart._createSampleData(),animate: true)),
                  Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Text("Harvest in:", style: TextStyle(fontSize: 35.00, color: Colors.black54),),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("3 days", style: TextStyle(fontSize: 70.00, color: Colors.black87,),),
                      ),
                    ),
                    Text("Berry Ripening Stage", style: TextStyle(fontSize: 20, color: Colors.black54),),
                  ],)),
                ],
              ),
            ),
            Legend(),
          ],
        ),
      )
    );
  }
}


/// Gauge chart example, where the data does not cover a full revolution in the
/// chart.


class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GaugeChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory GaugeChart.withSampleData() {
    return new GaugeChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        animationDuration: Duration(seconds: 2),
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 20, startAngle: 2 / 4 * pi, arcLength: 2 * pi));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final blue = charts.MaterialPalette.green.makeShades(2);
    final data = [
      new GaugeSegment('Inflorence', 10, Colors.green),
      new GaugeSegment('Flowering', 10, Colors.blue[400]),
      new GaugeSegment('Berry Development', 30, Colors.purple[400]),
      new GaugeSegment('Berry Deve', 30, Colors.purple[50]),
      new GaugeSegment('kulang', 10, Colors.red[50]),



    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        colorFn: (GaugeSegment segment, _) => segment.color,
        data: data,
      )
    ];
  }

}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;
  final charts.Color color;

  GaugeSegment(this.segment, this.size, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}