import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:grocery_vendor_app/widgets/drawer_menu_widget.dart';

import 'home_screen.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Dashboard Screen'),),
    );
  }
}
