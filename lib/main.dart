import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'bottom_example.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Tabs Demo'),
        ),
        body: new DefaultTabController(
          length: 3,
          child: new Column(
            children: <Widget>[
              new Container(
                constraints: BoxConstraints(maxHeight: 150.0),
                child: new Material(
                  color: Colors.indigo,
                  child: new TabBar(
                    tabs: [
                      new Tab(icon: new Icon(Icons.directions_car)),
                      new Tab(icon: new Icon(Icons.directions_transit)),
                      new Tab(icon: new Icon(Icons.directions_bike)),
                    ],
                  ),
                ),
              ),
              new Expanded(
                child: new TabBarView(
                  children: [
                    new Icon(Icons.directions_car),
                    new Icon(Icons.directions_transit),
                    new Icon(Icons.directions_bike),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}