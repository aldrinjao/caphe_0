import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:caphe_0/utils/questionaire_utils.dart';
import 'package:intl/intl.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({this.species, this.dates, this.harvest, this.tips});
  final List<String> tips;
  final DateTime harvest;
  final String species;
  final Map<String,DateTime> dates;
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  var dateFormatter = new DateFormat('dd-MMMM-yyyy');
  Questionaire questionaire = new Questionaire();
  var currentList;
  var defaultValues = ['completed', 'completed', 'completed', 'completed'];

  @override
  void initState() {
    super.initState();
    currentList = questionaire.firstSet;
    print(widget.tips);
  }

  getItems(species){
    var items = [
      TimelineModel(
          Card(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/'+widget.species+"/"+currentList[0].location,
                    height: 138.0,
                    fit: BoxFit.fill,
                  ),
                  Text("INFLORESENCE", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.dates['inflorence'] == null? defaultValues[0]: dateFormatter.format(widget.dates['inflorence']).toString(), style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              )),
          position: TimelineItemPosition.left,
          iconBackground: Colors.green[400],
          icon: Icon(Icons.blur_circular)),
      TimelineModel(
        Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text("${widget.tips[0] == "completed"? widget.tips[0] : dateFormatter.format(DateTime.parse(widget.tips[0]))}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Avoid spraying of insecticides! You might kill the pollinators. Flowering is coming up!", style: TextStyle(fontWeight: FontWeight.w300), ),

                ],
              ),
            )),
        position: TimelineItemPosition.right,
        iconBackground: Colors.grey,
        icon: Icon(Icons.data_usage),
      ),
      TimelineModel(
          Card(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/'+widget.species+"/"+currentList[1].location,
                    height: 138.0,
                    fit: BoxFit.fill,
                  ),
                  Text("FLOWERING", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.dates['flowering'] == null? defaultValues[0]: dateFormatter.format(widget.dates['flowering']).toString(), style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              )),
          position: TimelineItemPosition.left,
          iconBackground: Colors.blue[400],
          icon: Icon(Icons.blur_circular)),
      TimelineModel(
          Card(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/'+widget.species+"/"+currentList[2].location,
                    height: 138.0,
                    fit: BoxFit.fill,
                  ),
                  Text("BERRY DEVELOPMENT", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.dates['berry development'] == null? defaultValues[0]: dateFormatter.format(widget.dates['berry development']).toString(), style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              )),
          position: TimelineItemPosition.right,
          iconBackground: Colors.purple[400],
          icon: Icon(Icons.blur_circular)),
      TimelineModel(
        Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text("${widget.tips[1] == "completed"? widget.tips[1] : dateFormatter.format(DateTime.parse(widget.tips[1]))}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Observe for Coffee Brown-eye spot on the berries and leaves.", style: TextStyle(fontWeight: FontWeight.w300), ),

                ],
              ),
            )),
        position: TimelineItemPosition.left,
        iconBackground: Colors.grey,
        icon: Icon(Icons.data_usage),
      ),
      TimelineModel(
      Card(
      margin: EdgeInsets.all(8.0),
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    children: <Widget>[
      Text("${widget.tips[2] == "completed"? widget.tips[2] : dateFormatter.format(DateTime.parse(widget.tips[2]))}", style: TextStyle(fontWeight: FontWeight.bold)),
    Text("Coffee Berry Borers may attack your berries. Keep the farm free of ripe berries that may host CBB.", style: TextStyle(fontWeight: FontWeight.w300), ),

    ],
    ),
    )),
    position: TimelineItemPosition.right,
    iconBackground: Colors.grey,
    icon: Icon(Icons.data_usage)
      ),
      TimelineModel(
          Card(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/'+widget.species+"/"+currentList[3].location,
                    height: 138.0,
                    fit: BoxFit.fill,
                  ),
                  Text("BERRY RIPENING", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.dates['berry ripening'] == null? defaultValues[0]: dateFormatter.format(widget.dates['berry ripening']).toString(), style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              )),
          position: TimelineItemPosition.left,
          iconBackground: Colors.red[400],
          icon: Icon(Icons.blur_circular)),
      TimelineModel(
          Card(
            margin: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Harvest time! Pick red berries for high quality coffee.", style: TextStyle(fontWeight: FontWeight.bold), ),
                  ),
                  Text(dateFormatter.format(widget.harvest).toString(), style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              )),
          position: TimelineItemPosition.right,
          iconBackground: Colors.brown[400],
          icon: Icon(Icons.assistant_photo,)),

    ];
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return Timeline(
      shrinkWrap: true,
      children: getItems(widget.species),
      position: TimelinePosition.Center,
      physics: BouncingScrollPhysics(),
    );
  }
}
