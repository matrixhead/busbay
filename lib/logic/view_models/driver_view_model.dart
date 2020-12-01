import 'dart:async';
import 'dart:typed_data';

import 'package:busbay/logic/Services/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';

class DriverMapView extends ChangeNotifier {
  StreamSubscription locationSubscription;
  Marker marker;
  Circle circle;
  CameraPosition initialLocation;
  GoogleMapController mapController;
  List<Bus> busList = [];
  Bus selectedBus;
  Location _locationTracker;

  DriverMapView() {
    initialLocation =
        CameraPosition(target: LatLng(9.577142, 76.622592), zoom: 14.4746);
    _locationTracker = Location();
    loadBusData();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void loadBusData() async {
    busList = await getAllBus();
    notifyListeners();
  }

  void showbus(Bus bus) {
    selectedBus = bus;
    notifyListeners();
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await rootBundle.load("assets/images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);

    marker = Marker(
        markerId: MarkerId("home"),
        position: latlng,
        rotation: newLocalData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData));
    circle = Circle(
        circleId: CircleId("car"),
        radius: newLocalData.accuracy,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latlng,
        fillColor: Colors.blue.withAlpha(70));
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (locationSubscription != null) {
        locationSubscription.cancel();
      }

      locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));

          updateMarkerAndCircle(newLocalData, imageData);
          notifyListeners();
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
}
