import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:caphe_0/screens/home.dart';
import 'package:caphe_0/screens/welcome.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureResult) {

          if (futureResult.connectionState == ConnectionState.done) {
            if (futureResult.data == null) {
              return WelcomeScreen();
            }
            return HomeScreen(user: futureResult.data);
          }

          return Center(child: Container(child: CircularProgressIndicator()));
        }
    );
  }
}
