import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:busbay/PassengerBusList.dart';

class PBus1 extends StatefulWidget {
  @override
  _PBusNo1State createState() => _PBusNo1State();
}

class _PBusNo1State extends State<PBus1> {
  GoogleMapController mapController;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Circle circle;
  Marker marker;
  //final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  
  }
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(9.577142, 76.622592),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/images/car_icon.png");
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
          
          flat: true,
          anchor: Offset(0.78,0.78),
          icon: BitmapDescriptor.defaultMarker
        );
        circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
      
    });
  }

  void _animateCamera(LocationData _locationdata,Uint8List imageData){
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(_locationdata.latitude, _locationdata.longitude),
        tilt: 0,
        zoom: 18.00)));
        updateMarker(_locationdata, imageData);
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
      _animateCamera(location, imageData);
     

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
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.blue[700],
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          onMapCreated: _onMapCreated,
          initialCameraPosition: initialLocation,
          markers: Set.of((marker != null) ? [marker] : []),
          circles: Set.of((circle != null) ? [circle] : []),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location),
          onPressed:(){
            getCurrentLocation();
          } ),
      ),
    );
  }
}