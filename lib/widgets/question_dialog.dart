import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caphe_0/screens/questionaire.dart';

class QuestionDialog extends StatefulWidget {
  @override
  const QuestionDialog({Key key, this.user, this.weather}) : super(key: key);
  final FirebaseUser user;
  final DocumentSnapshot weather;

  _QuestionDialogState createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  var options;
  var locations = [];

  String plantationName = '';
  String selectedLocation;

  void initState() {
    locations.add({'name': 'Please select a location', 'id': 'no'});
    widget.weather.data.forEach((k, v) {
      locations.add({'name': v['name'], 'id': k});
    });


    selectedLocation = locations[0]['id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Answer the following Questions:',
        style: TextStyle(color: Colors.green),
      ),
      content: new Container(
        height: 175,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                "What do you want to name your plantation?",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              new TextField(
                decoration: new InputDecoration(
                    labelText: 'Plantation Name',
                    hintText: 'eg. Plantaion Uno'),
                onChanged: (value) {
                  plantationName = value;
                },
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              new Text(
                "Where is your plantation located?",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              DropdownButton<String>(
                  value: selectedLocation,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedLocation = newValue;
                    });
                  },
                  items: locations.map<DropdownMenuItem<String>>((location) {
                    return DropdownMenuItem<String>(
                      value: location['id'],
                      child: Text(location['name']),
                    );
                  }).toList()),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            if(selectedLocation!='no'){
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new QuestionairePage(
                  name: plantationName,
                  user: widget.user,
                  location: selectedLocation,
                ), fullscreenDialog: true));}
          },
        ),
      ],
    );

  }

}

