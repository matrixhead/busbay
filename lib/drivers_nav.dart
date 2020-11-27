
import 'package:flutter/material.dart';
import 'DriverBusList.dart';
import 'Driver/profile.dart';
import 'Driver/Settings.dart';

class BNav extends StatefulWidget {
  @override
  _BNavState createState() => _BNavState();
}

class _BNavState extends State<BNav> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    driverspeeddail(),
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
            backgroundColor: Color.fromRGBO(
                39, 105, 171, 1),
            label: "BUS",
            
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_rounded
            ),
            label: "profile",
            backgroundColor:  Color(0xFF040021),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "settings",
            backgroundColor: Color.fromRGBO(
                39, 105, 171, 1),
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