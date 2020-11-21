// edit need in pubsec.yaml,build,gradle,setting.gradle
import 'package:busbay/logic/Services/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'DBusNo1.dart';

void main() {
  runApp(MaterialApp(
      home: driverspeeddail(), title: 'Flutter Speed Dial Examples'));
}

class driverspeeddail extends StatefulWidget {
  @override
  driverspeeddailState createState() => driverspeeddailState();
}

class driverspeeddailState extends State<driverspeeddail>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  bool dialVisible = true;
  Bus _selectedBus;

  void _showbus(Bus bus) {
    setState(() {
      _selectedBus = bus;
    });
  }

  SpeedDialChild buildSpeedDialChild(Bus bus) {
    return SpeedDialChild(
      child: Text(
        bus.id.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      backgroundColor: Colors.lightBlueAccent,
      onTap: () {
        _showbus(bus);
      },
      label: 'route ' + bus.id.toString(),
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
      labelBackgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: DBus1(bus: _selectedBus),
        ),
        floatingActionButton: FutureBuilder(
            future: getAllBus(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  // child: Icon(Icons.add),
                  onOpen: () => print('OPENING DIAL'),
                  onClose: () => print('DIAL CLOSED'),
                  visible: dialVisible,
                  curve: Curves.bounceIn,
                  children: snapshot.data
                      .map<SpeedDialChild>((bus) => buildSpeedDialChild(bus))
                      .toList(),
                );
              } else {
                return CircularProgressIndicator();
              }
            })
    );
  }
}
