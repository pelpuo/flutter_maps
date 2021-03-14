import 'package:flutter/material.dart';
import 'package:solutions_challenge/widgets/map_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;

    return Scaffold(
        key: _drawerKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text(
                  'Header',
                ),
                decoration: BoxDecoration(color: Colors.black38),
              ),
              ListTile(
                title: Text('Your Trips'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Payments'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Routes'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      //Map
                      width: width,
                      height: height - padding.top - padding.bottom,
                      child: MapWidget(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          // alignment: Alignment.topLeft,
                          iconSize: 36,
                          padding: EdgeInsets.all(12),
                          icon: Icon(Icons.menu),
                          color: Colors.black,
                          onPressed: () {
                            _drawerKey.currentState.openDrawer();
                          },
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
