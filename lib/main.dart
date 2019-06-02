import 'package:flutter/material.dart';
import 'package:caphe_0/screens/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAPHE',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
      ),
      home: Root(),
    );
  }
}

