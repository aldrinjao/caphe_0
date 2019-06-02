import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StepperContainer extends StatelessWidget {
  final results;
  final data;
  final DateTime harvest;
  final DocumentSnapshot weather;
  const StepperContainer(this.data, this.results,{this.harvest, this.weather});


  getItems() {
    var dateFormatter =  DateFormat('dd-MMMM-yyyy');
    print(weather.data['cavite']['name']);
    var items = [
      TimelineModel(
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Colors.green[200],
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "STEP 1",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            RichText(
                              text: new TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: 'Upon registration ('),
                                  new TextSpan(
                                      text: '${dateFormatter.format(data['date'].toDate()).toString()}',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  new TextSpan(
                                      text: '), the system was able to identify that the current BBCH stage of your coffee located at ',),
                                  new TextSpan(
                                      text: '${weather.data[data['location']]['name']}',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  new TextSpan(
                                    text: ' is at ',),
                                  new TextSpan(
                                      text: '${data['bbch']}.',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          position: TimelineItemPosition.left,
          iconBackground: Colors.green[400],
          icon: Icon(Icons.blur_circular)),
      TimelineModel(
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Colors.blue[200],
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "STEP 2",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            RichText(
                              text: new TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: 'Using the simulated weather data for '),
                                  new TextSpan(
                                      text: '${weather.data[data['location']]['name']}',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),

                                  new TextSpan(
                                    text: ' and the given BBCH stage, your plantation needs  ',),
                                  new TextSpan(
                                      text: '${results.targetBbch}',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  new TextSpan(
                                    text: ' growing-degree-day (GDD) before harvest time.',),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          position: TimelineItemPosition.left,
          iconBackground: Colors.blue[400],
          icon: Icon(Icons.blur_circular)),
      TimelineModel(
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Colors.purple[200],
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "STEP 3",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            RichText(
                              text: new TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: 'As plotted on the phenology calendar, your predicted harvest date is when the crop reach '),
                                  new TextSpan(
                                      text: '${results.targetBbch}',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  new TextSpan(
                                    text: ' GDD which is on ',),

                                  new TextSpan(
                                      text: '${dateFormatter.format(harvest).toString()}.',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          position: TimelineItemPosition.left,
          iconBackground: Colors.purple[400],
          icon: Icon(Icons.blur_circular)),
    ];
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Forecasting Process", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300, color: Colors.black87),)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Timeline(
              shrinkWrap: true,
              children: getItems(),
              position: TimelinePosition.Left,
              physics: BouncingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
