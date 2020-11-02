
import 'package:flutter/material.dart';
import 'DriverBusList.dart';
import 'Driver/profile.dart';


class BNav extends StatefulWidget {
  @override
  _BNavState createState() => _BNavState();
}

class _BNavState extends State<BNav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    driverspeeddail(),
    ProfilePassenger(),
    Text('Profile Screen'),
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
              Icons.bus_alert,
              
            ),
            backgroundColor: Colors.blueAccent,
            label: "BUS",
            
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person
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