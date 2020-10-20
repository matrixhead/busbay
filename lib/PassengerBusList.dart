import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'PBusNo1.dart';

void main() {
  runApp(MaterialApp(home: passengerspeeddail(), title: 'Flutter Speed Dial Examples'));
}

class passengerspeeddail extends StatefulWidget {
  @override
  passengerspeeddailState createState() => passengerspeeddailState();
}

class passengerspeeddailState extends State<passengerspeeddail> with TickerProviderStateMixin {
  ScrollController scrollController;
  bool dialVisible = true;
  
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    PBus1(),
    PBus1(),
    PBus1(),
  ];

  void _showbus(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child:Text('1',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),
          ),
          backgroundColor: Colors.lightBlueAccent,
          onTap:(){
            _showbus(0);
          },
          label: 'route 1',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.white,
        ),
        SpeedDialChild(
          child:Text('2',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),
          ),
          backgroundColor: Colors.lightBlueAccent,
          onTap: (){
            _showbus(1);
          },
          label: 'route 2',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.white,
        ),
        SpeedDialChild(
          child:Text('3',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),
          ),
          backgroundColor: Colors.lightBlueAccent,
          onTap: () {
           _showbus(2);
          },
          label: 'route 3',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.white,
         
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
 
      
      floatingActionButton: buildSpeedDial(),
    );
  }
}
