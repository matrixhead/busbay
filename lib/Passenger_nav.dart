
import 'package:flutter/material.dart';
import 'PassengerBusList.dart';
import 'Passenger/profile.dart';
import 'Passenger/Settings.dart';


class PNav extends StatefulWidget {
  @override
  _PNavState createState() => _PNavState();
}

class _PNavState extends State<PNav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    passengerspeeddail(),
    ProfileScreen(),
    SettingsPassenger(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
            backgroundColor: Color(0xFF040021),
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