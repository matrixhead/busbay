import 'dart:typed_data';

import 'package:busbay/logic/Services/auth.dart';
import 'package:busbay/logic/Services/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../service_locator.dart';

class MapView extends ChangeNotifier {

  AuthService authService = serviceLocator<AuthService>();

  GoogleMapController mapController;
  CameraPosition initialLocation;
  Map<int, Marker> markerList = {};
  List<Circle> circleList = [];
  Location _locationTracker;
  List<Bus> busList = [];
  Bus selectedBus;
  String currentUser;

  MapView() {
    initialLocation =
        CameraPosition(target: LatLng(9.577142, 76.622592), zoom: 14.4746);
    _locationTracker = Location();
    loadBusData();
    currentUser=authService.getCurrentUserid();
    print(currentUser);
  }

  void loadBusData() async {
    busList = await getAllBus();
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _animateCamera(LatLng _locationdata) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          initialLocation = CameraPosition(
              bearing: 192.8334901395799,
              target: _locationdata,
              tilt: 0,
              zoom: 18.00)));
      notifyListeners();
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
      updateDroppedPins(selectedBus, currentUser, location);
      _animateCamera(LatLng(location.latitude, location.longitude));
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void showbus(Bus bus) {
    trackBus(bus);
    selectedBus=bus;
    notifyListeners();
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await rootBundle.load("assets/images/car_icon.png");
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
}
