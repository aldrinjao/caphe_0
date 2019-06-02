import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:caphe_0/widgets/legend.dart';
import 'package:caphe_0/widgets/timelines.dart';
class CircleTracker extends StatefulWidget {
  const CircleTracker({Key key, this.daysLeft,this.species, this.finishedStages, this.dates, this.harvest, this.tips}) : super(key: key);
  final int daysLeft;
  final String species;
  final Set<String> finishedStages;
  final DateTime harvest;
  final Map<String,DateTime> dates;
  final List<String> tips;
  @override
  _CircleTrackerState createState() => _CircleTrackerState();
}

class _CircleTrackerState extends State<CircleTracker> {
  @override
  Widget build(BuildContext context) {
    return  ListView(
      children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(child: Text("Track your harvest dates and phenological stage using the BBCH scale.", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,  ),textAlign: TextAlign.center, )),
                  ),
                 Stack(
                   alignment: Alignment.center,
                  children: <Widget>[
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft, //this one is the grey sliver thingy that indicates the current stage.
                      child: Center(child:Container(height: 800, width: 800,child: GaugeChart(GaugeChart.createRingData(widget.species, widget.finishedStages,true),animate: true,species: widget.species, inner: true)),),),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft, //this one is for the colored stuff not the grey sliver thingy
                      child: Center(child:Container(height: 800, width: 800,child: GaugeChart(GaugeChart.createRingData(widget.species, widget.finishedStages,false),animate: true,species: widget.species, inner: false),)),),

                    FittedBox( //this is so that di na lalagpas... hopefully.
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Harvest in:", style: TextStyle(fontSize: 40.00, color: Colors.black54, fontWeight: FontWeight.w300),),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("${widget.daysLeft} days", style: TextStyle(fontSize: 70.00, color: Colors.black87, fontWeight: FontWeight.w400),),
                        ),
                      ),
                      Text(widget.finishedStages.last, style: TextStyle(fontSize:20, color: Colors.black54, fontWeight: FontWeight.w300),)
                    ],)
                  ),
                  ],
                ),
              Legend(),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Center(child: Text("Phenological Stages", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300, color: Colors.black87),)),
                 ),
                 TimelineScreen(
                   species: widget.species,
                   dates: widget.dates,
                   harvest: widget.harvest,
                   tips: widget.tips,
                 )
            ],
    );
  }
}


/// Gauge chart example, where the data does not cover a full revolution in the
/// chart.


class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String species;
  final bool inner;
  GaugeChart(this.seriesList, {this.animate, this.species, this.inner});

  @override
  Widget build(BuildContext context) {
    var arcWidth = inner? 35 : 25;
    return new charts.PieChart(seriesList,
        animate: animate,
        animationDuration: Duration(seconds: 2),
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.

        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: arcWidth, startAngle: 2 / 4 * pi, arcLength: 2 * pi));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> createRingData(String species, Set<String> finishedStages, bool inner) {
    final values = {'robusta': [95,37,227,57], 'arabica': [77,21,178,88], 'excelsa': [84,84,232,48], 'liberica': [100,68,201,86]}; //this information was retrieved from the coffee team's slides. This is in days.

    final data = [
      new GaugeSegment('Inflorence', values[species][0], finishedStages.contains('inflorescence') && inner? Colors.grey : inner? Colors.transparent : Colors.green[400]),
      new GaugeSegment('Flowering', values[species][1], finishedStages.contains('flowering') && inner? Colors.grey : inner? Colors.transparent :Colors.blue[400]),
      new GaugeSegment('Berry Development', values[species][2], finishedStages.contains('berry development') && inner? Colors.grey : inner? Colors.transparent :Colors.purple[400]),
      new GaugeSegment('kulang', values[species][3], finishedStages.contains('berry ripening') && inner? Colors.grey : inner? Colors.transparent :Colors.red[400]),

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

