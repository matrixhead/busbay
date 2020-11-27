import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'PBusNo1.dart';
import 'logic/data.dart';

class passengerspeeddail extends StatefulWidget {
  @override
  passengerspeeddailState createState() => passengerspeeddailState();
}

class passengerspeeddailState extends State<passengerspeeddail>
    with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  Map<int, Marker> markerList = {};
  List<Circle> circleList = [];
  Location _locationTracker = Location();
  GoogleMapController mapController;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(9.577142, 76.622592),
    zoom: 14.4746,
  );

  void _showbus(Bus bus) {
    setState(() {
      trackBus(bus);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

  void _animateCamera(LatLng _locationdata) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: _locationdata,
              tilt: 0,
              zoom: 18.00)));
      setState(() {});
    }
  }

  void dropPassengerMarker() async {
    try {
      LocationData location = await _locationTracker.getLocation();
      markerList[0] = Marker(
          markerId: MarkerId("home"),
          position: LatLng(location.latitude, location.longitude),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.78, 0.78),
          icon: BitmapDescriptor.defaultMarker);
      circleList.insert(
          0,
          Circle(
              circleId: CircleId("car"),
              radius: location.accuracy,
              zIndex: 1,
              strokeColor: Colors.blue,
              center: LatLng(location.latitude, location.longitude),
              fillColor: Colors.blue.withAlpha(70)));
      _animateCamera(LatLng(location.latitude, location.longitude));
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  Future<void> trackBus(Bus bus) async {
    if (bus != null) {
      Uint8List imageData = await getMarker();
      getBusLoc(bus).listen((snapshot) {
        GeoPoint point = snapshot.data()['points'];
        markerList[1] = Marker(
            markerId: MarkerId("bus"),
            position: LatLng(point.latitude, point.longitude),
            rotation: snapshot.data()['heading'],
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.78, 0.78),
            icon: BitmapDescriptor.fromBytes(imageData));
        _animateCamera(LatLng(point.latitude, point.longitude));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text('Bus No.1'),
          backgroundColor: Colors.blue[700],
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          scrollGesturesEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: initialLocation,
          markers: Set.of(markerList.values.toList() ?? []),
          circles: Set.of(circleList ?? []),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_location),
            onPressed: () {
              dropPassengerMarker();
            }),
      ),
      floatingActionButton: FutureBuilder(
          future: getAllBus(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                curve: Curves.bounceIn,
                children: snapshot.data
                    .map<SpeedDialChild>((bus) => buildSpeedDialChild(bus))
                    .toList(),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
