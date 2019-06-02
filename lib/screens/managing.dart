import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PlantationManager extends StatefulWidget {
  const PlantationManager({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _PlantationManagerState createState() => _PlantationManagerState();
}

class _PlantationManagerState extends State<PlantationManager> {
  final db = Firestore.instance;
  var dateFormatter = new DateFormat('dd-MMMM-yyyy');
  DocumentSnapshot weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Managing Plantations")),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: db.collection('users').document(widget.user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //return Text(snapshot.data['records'].toString());
//                return process(context, snapshot.data);
//              return _buildBody(context, snapshot.data);
              return FutureBuilder(
                  future: Future.wait([getWeatherData(),]),
                  builder: (_, futureSnapshot) {
                    if (futureSnapshot.hasData) {
                      print("Rebuilt body");
                      if(snapshot.data['records'] != null){
                        return Column(
                            children: List<Widget>.from(
                                snapshot.data['records'].map((doc) => ItemCard(doc))).toList());
                      }else{
                        return SizedBox();
                      }

                    } else {
                      return Center(
                          child: Container(child: CircularProgressIndicator()));
                    }
                  });
            } else {
              return Center(
                  child: Container(child: CircularProgressIndicator()));
            }
          },
        ),
      ),
    );
  }

  //List tile doc passes info about the plantation
  Widget ItemCard(doc) {
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "${doc['name']}",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Date of registration: ${dateFormatter.format(doc['date'].toDate())}",
              style:
              TextStyle(fontWeight: FontWeight.w300),
            ),
            Text(
                "BBCH at time of registration: ${doc['bbch']}",
                style: TextStyle(
                    fontWeight: FontWeight.w300)),
            Text("Species: ${doc['species']}",
                style: TextStyle(
                    fontWeight: FontWeight.w300)),
            Text("Location: ${weather.data[doc['location']]['name']}",
                style: TextStyle(
                    fontWeight: FontWeight.w300))
          ],
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: () {
              _showDialog(doc['name'],
                  Map<String, dynamic>.from(doc));
            }),
      ),
    );
  }

  //asks user if they're sure they want to delete the plantation
  void _showDialog(String name, Map<String, dynamic> doc) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(
                    text: 'Are you sure you want to delete: ',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
                new TextSpan(
                    text: '${name}',
                    style: new TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                new TextSpan(text: ' ?'),
              ],
            ),
          ),
          content:
              new Text("This will permanently delete it from your records."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Remove"),
              onPressed: () {
                deleteDoc(doc);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteDoc(Map<String, dynamic> doc) async {
    try {
      await db.collection('users').document(widget.user.uid).updateData({
        "records": FieldValue.arrayRemove([doc])
      });
    } catch (e) {
      print(e.message);
    }
  }
  Future<DocumentSnapshot> getWeatherData() async {
    var document =
    Firestore.instance.collection("model").document("weatherData").get();
    this.weather = await document;
  }
}
