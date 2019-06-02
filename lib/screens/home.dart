import 'package:flutter/material.dart';
import 'package:caphe_0/widgets/drawer.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:caphe_0/widgets/circle_tracker.dart';
import 'package:caphe_0/widgets/tab_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caphe_0/models/calculator.dart';
import 'package:caphe_0/widgets/calendar.dart';
import 'package:caphe_0/widgets/question_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:caphe_0/widgets/how.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //FIRESTORE
  final db = Firestore.instance;

  //BOTTOM NAVIGATION
  int lastTab = 0;
  int selectedPos = 0;
  double bottomNavBarHeight = 60;
  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.green),
    new TabItem(Icons.today, "Calendar", Colors.blue),
    new TabItem(Icons.info, "How", Colors.purple[400]),
  ]);
  CircularBottomNavigationController _navigationController;

  //TAB NAVIGATION
  TabController tabController;

  //DATA
  DocumentSnapshot weather;


  @override
  void initState() {
    super.initState();
    //FOR BOTTOM NAVIGATION
    _navigationController = new CircularBottomNavigationController(selectedPos);
    //GETTING DATA
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerContainer(user: widget.user),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FlatButton(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: <Widget>[
                    Text("CAPHE", style: TextStyle(fontSize: 20, color: Colors.green),),
                    Text("Coffee Harvest Estimator", style: TextStyle(fontSize: 10),)
                  ],
                ),
              ),
              onPressed: () {
                setState(() {
                  scrollDown();
                  _navigationController.value = 0; //this is so it goes back to home
                });
              },
            ),
            Expanded(child: Container(),),
            Image.asset(
              'assets/logos/sarai.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Image.asset(
              'assets/logos/dost-pcaarrd-uplb.png',
              fit: BoxFit.contain,
              height: 32,
            ),

          ],
        ),
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<DocumentSnapshot>(
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
//                      print(snapshot.data['records'].length);
                      return _buildBody(snapshot.data);
                    } else {
                      return Center(
                          child: Container(child: CircularProgressIndicator()));
                    }
                  });
            } else {
              return Center(
                  child: Container(child: CircularProgressIndicator()));
            }
          }),
      bottomNavigationBar: bottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: addValue,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }


  void scrollDown(){
    Flushbar(
      message: "Scrolldown to see the timeline",
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      aroundPadding: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  //BOTTOM NAVIGATION
  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          lastTab = tabController.index;
          this.selectedPos = selectedPos;
          if (this.selectedPos == 0){
            scrollDown();
          }
          print(_navigationController.value);
        });
      },
    );
  }

//this instigates the creation of a new plantation.
  void addValue() async {
    if (weather != null) {
      final String name = await _asyncInputDialog(context);
      print(name);
    }
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return QuestionDialog( //this is the dialog that asks for the name and location
          user: widget.user,
          weather: weather,
        );
      },
    );
  }


  Widget _buildBody(DocumentSnapshot snapshot) {
    var records = (snapshot != null && snapshot['records'] != null)
        ? snapshot["records"].reversed.toList()
        : [];
    tabController =
        new TabController(vsync: this, length: records.length, initialIndex: lastTab);

    return new Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text("Plantation Names", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, ), ),
      ),
      TabBarContainer(
          controller: tabController,
          colors: [Colors.white, Colors.blue, Colors.green],
          items: new List<Widget>.from(records
              .map((data) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(data['name'].toString())))
              .toList())),
      Expanded(
        child: records.length == 0
            ? Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                    child: Text(
                  "Press the + button below to add your first record",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 40.0),
                )))
            : TabBarView(
                controller: tabController,
                children:
                    elementsContainer(selectedPos, records) ?? [Container()]),
      )
    ]);
  }

  List<Widget> elementsContainer(int selectedPos, records) {
    var calculator = Calculator(weatherData: weather);
    List<Widget> result;
    switch (selectedPos) {
      case 0:
        {
          result = new List<Widget>.from(records
              .map(
                (data) {
                  var calculatorResult = calculator.getResult(data);
                  return CircleTracker(
                      dates: calculatorResult.stages,
                      harvest: calculatorResult.harvestDate,
                      daysLeft: calculatorResult.daysLeft,
                      finishedStages: calculatorResult.finishedStages,
                      species: data['species'],
                      tips: calculatorResult.tips);
                }
              )
              .toList());
        }
        break;
      case 1:
        {
          result = new List<Widget>.from(records
              .map((data) =>
                  CalendarTracker(events: calculator.getResult(data).events))
              .toList());
        }
        break;
      case 2:
        {
          result = new List<Widget>.from(
              records.map((data) => StepperContainer(data, calculator.getResult(data), harvest: calculator.getResult(data).harvestDate,weather: weather)).toList());
        }
        break; //Text(data['bbch'].toString())
      default:
        result = [Container(color: Colors.black)];
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }

  Future<DocumentSnapshot> getWeatherData() async {
    var document =
        Firestore.instance.collection("model").document("weatherData").get();
    this.weather = await document;
  }


}

