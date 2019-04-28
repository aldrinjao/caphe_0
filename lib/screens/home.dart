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
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: DrawerContainer(),
        appBar: AppBar(
          title: Text(
            "CAPHE",
            style: TextStyle(color: Colors.black54),
          ),
          iconTheme: IconThemeData(color: Colors.green),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: List.generate(3, (index) {
              return new Text("plantation: $index",
                  style: TextStyle(color: Colors.black54));
            }),
          ),
        ),
        body: TabBarView(
          children: [
            Text(selectedPos.toString()),
            Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.blue)
            ,
            CircleTracker(),
          ],
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
      ),
    );
  }

  Widget bodyContainer() {
    Color selectedColor = tabItems[selectedPos].color;
    String slogan;
    switch (selectedPos) {
      case 0:
        slogan = "Home Show Gauge Chart";
        break;
      case 1:
        slogan = "Show calendar";
        break;
      case 2:
        slogan = "Show about";
        break;
      case 3:
        slogan = "Show timeline";
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: Center(
          child: Text(
            slogan,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value++;
        }
      },
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
