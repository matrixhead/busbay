
import 'package:flutter/material.dart';
import 'PassengerBusList.dart';
import 'Passenger/profile.dart';
import 'package:busbay/Passenger/Settings.dart';
import 'package:busbay/logic/Services/pro.dart';


class PNav extends StatefulWidget {
  @override
  _PNavState createState() => _PNavState();
}

class _PNavState extends State<PNav> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    passengerspeeddail(),
    ProfileScreen(),
    SettingsPassenger(),
  ];

  void _onPageChanged(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  void _onItemTap(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.directions_bus,

            ),
            backgroundColor: Colors.blueAccent,
            label: "BUS",

          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_rounded
            ),
            label: "profile",
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "settings",
            backgroundColor: Colors.blueAccent,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}