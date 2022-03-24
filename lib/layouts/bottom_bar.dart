import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:visitor_management/layouts/walkin_customer_list.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'gate_entry.dart';
import 'homepage.dart';
// import 'screens/cart.dart';
// import 'screens/home.dart';
// import 'screens/search.dart';
// import 'screens/user.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);
  static const routeName = '/BottomBarScreen';

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  // List _pages = [
  //   HomeScreen(),
  //   FeedsScreen(),
  //   SearchScreen(),
  //   CartScreen(),
  //   UserSection(),
  // ];

  late List<Map<String, Widget>> _pages;
  int selectedIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': NewHomePage(),
      },
      {
        'page': WalkinCustomerList(),
      },
      {
        'page': GateEntry(),
      },
    ];
    super.initState();
  }

  void selectedPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[selectedIndex]['page'],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue,
        ),
        child: BottomAppBar(
          // shape: CircularNotchedRectangle(),
          child: BottomNavigationBar(
            onTap: selectedPage,
            backgroundColor: gradientColor1,
            unselectedItemColor: Theme.of(context).textSelectionColor,
            selectedItemColor: Colors.white,
            currentIndex: selectedIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), tooltip: 'Home', label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.vertical_split),
                  tooltip: 'Walk-in Customer',
                  label: 'Walk-in Customer'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), tooltip: 'Gate Entry', label: 'Gate Entry'),
            ],
          ),
        ),
      ),
    );
  }
}
