import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'logic/data.dart';

class PBus1 extends StatefulWidget {
  final Bus bus;
  PBus1({Key key, this.bus}) : super(key: key);
  @override
  _PBusNo1State createState() => _PBusNo1State();
}

class _PBusNo1State extends State<PBus1> {
  GoogleMapController mapController;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Circle circle;
  Marker marker;
  List<Marker> markerList = [];
  List<Circle> circleList = [];

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(9.577142, 76.622592),
    zoom: 14.4746,
  );
  @override
  void initState() {
    getBusLoc(widget.bus).listen((snapshot) {
      if (snapshot.hasData) {
        GeoPoint point=snapshot.data['points'];
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(point.latitude, point.longitude),
                tilt: 0,
                zoom: 18.00)));
      }
    });
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarker(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat:
              true, //final LatLng _center = const LatLng(45.521563, -122.677433);
          anchor: Offset(0.78, 0.78),
          icon: BitmapDescriptor.defaultMarker);
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void _animateCamera(LocationData _locationdata) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(_locationdata.latitude, _locationdata.longitude),
              tilt: 0,
              zoom: 18.00)));
    }
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarker(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      // _animateCamera(location, imageData);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void dropPassengerMarker() async {
    try {
      LocationData location = await _locationTracker.getLocation();
      markerList.insert(
          0,
          Marker(
              markerId: MarkerId("home"),
              position: LatLng(location.latitude, location.longitude),
              draggable: false,
              zIndex: 2,
              flat: true,
              anchor: Offset(0.78, 0.78),
              icon: BitmapDescriptor.defaultMarker));
      circleList.insert(
          0,
          Circle(
              circleId: CircleId("car"),
              radius: location.accuracy,
              zIndex: 1,
              strokeColor: Colors.blue,
              center: LatLng(location.latitude, location.longitude),
              fillColor: Colors.blue.withAlpha(70)));
      _animateCamera(location);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
          markers: Set.of(markerList ?? []),
          circles: Set.of(circleList ?? []),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_location),
            onPressed: () {
              //getCurrentLocation();
              setState(() {
                dropPassengerMarker();
              });
            }),
      ),
    );
  }
}
