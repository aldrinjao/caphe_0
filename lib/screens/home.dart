import 'package:flutter/material.dart';
import 'package:caphe_0/widgets/drawer.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:caphe_0/widgets/circle_tracker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //this is for the bottom navigation
  int selectedPos = 0;
  List<Color> _tabColors = [Colors.green[400], Colors.blue[400], Colors. purple[400], Colors.red[400]];
  Color _tabColor;
  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.green),
    new TabItem(Icons.today, "Calendar", Colors.blue),
    new TabItem(Icons.info, "About", Colors.purple[400]),
    new TabItem(Icons.timeline, "Timeline", Colors.red[400]),
  ]);

  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = new CircularBottomNavigationController(selectedPos);
    _tabColor = _tabColors[0];
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        drawer: DrawerContainer(),
        appBar: AppBar(
          title: Text(
            "CAPHE",
            style: TextStyle(color: Colors.black54),
          ),
          iconTheme: IconThemeData(color: Colors.green),
          backgroundColor: Colors.white,
          elevation: 1,

        ),
        body: new DefaultTabController(
          length: 3,
          child: new Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(4),),
              new Container(
                decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), color: Colors.grey[300]),
                constraints: BoxConstraints(maxHeight: 150.0),
                child: new Material(
                  color: Colors.white70,
                  child: new TabBar(
                    unselectedLabelColor: Colors.black54,
                    isScrollable: true,
                    indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), gradient: LinearGradient(colors: [Colors.green, Colors.blue])),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("penritnse"),
                      ),
                      Text("WATHSEST"),
                      Text("WENTST")

                    ],
                  ),
                ),
              ),
              new Expanded(
                child: new TabBarView(
                  children: [
                    new Icon(Icons.directions_car),
                    new Icon(Icons.directions_transit),
                    CircleTracker(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNav(),
//        TabBarView(
//          children: [
//            Icon(Icons.directions_car),
//            Icon(Icons.directions_transit),
//            Icon(Icons.directions_bike),
//          ],
//        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.blue,
          child: Icon(Icons.add),
        ),
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos;
          _tabColor = _tabColors[selectedPos];
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
