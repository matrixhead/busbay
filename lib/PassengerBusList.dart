import 'package:busbay/logic/view_models/Passenger_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'logic/Services/data.dart';
import 'logic/service_locator.dart';

import 'package:flushbar/flushbar.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class passengerspeeddail extends StatefulWidget {
  @override
  passengerspeeddailState createState() => passengerspeeddailState();
}

class passengerspeeddailState extends State<passengerspeeddail>
    with TickerProviderStateMixin,AutomaticKeepAliveClientMixin  {
  PassengerMapView mapView = serviceLocator<PassengerMapView>();


  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  void fcmSubscribe() {
    firebaseMessaging.subscribeToTopic('Passenger');
    firebaseMessaging.subscribeToTopic('Passenger1');
  }

  void fcmUnSubscribe() {
    firebaseMessaging.unsubscribeFromTopic('Passenger');
  }

  void _showflushbar() {
     Flushbar(
      title: "Bus No1",
      message: "started at 8:30AM",
      duration: Duration(seconds: 4),
      flushbarPosition:FlushbarPosition.TOP,
      backgroundColor: Colors.blueAccent,
    )..show(context);
  }


 // final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
 // _showsnackbar(){
 //   final snackbar = new SnackBar(
   //     content:new Text("demo snackbar"),
     //   duration: new Duration (seconds: 4),
     //   backgroundColor: Colors.blue,

      //  action: new SnackBarAction(label: 'close', onPressed: (){
       //   print("snackbar closed");}
      //  ),
  //  );

  //  _scaffoldkey.currentState.showSnackBar(snackbar);



  SpeedDialChild buildSpeedDialChild(Bus bus, context) {
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
        Provider.of<PassengerMapView>(context, listen: false).showbus(bus);
      },
      label: 'route ' + bus.id.toString(),
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
      labelBackgroundColor: Colors.white,
    );
  }


 // void initState() {
  //  super.initState();
   // _showflushbar();
  //  WidgetsBinding.instance.addPostFrameCallback((_) => _showflushbar());
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PassengerMapView>(create: (context) => mapView),
      ],
      child: Consumer<PassengerMapView>(builder: (context, view, child) {
        return Scaffold(
          body: Scaffold(
            //key:_scaffoldkey,
            appBar: AppBar(
              title: Text(view.selectedBus?.name ?? "select a bus"),
              backgroundColor: Colors.blue[700],
            ),
            body: GoogleMap(
              mapType: MapType.normal,
              scrollGesturesEnabled: true,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: view.onMapCreated,
              initialCameraPosition: view.initialLocation,
              markers: Set.of(view.markerList.values.toList() ?? []),
              circles: Set.of(view.circleList ?? []),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add_location),
                onPressed: () {
                  view.dropPassengerMarker();
                  //_showflushbar();

                  fcmSubscribe();

                }),
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.bounceIn,
            children: view.busList
                .map<SpeedDialChild>((bus) => buildSpeedDialChild(bus, context))
                .toList(),
          ),
        );
      }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
