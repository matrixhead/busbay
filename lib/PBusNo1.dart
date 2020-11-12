import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  Map <int,Marker> markerList={} ;
  List<Circle> circleList = [];

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(9.577142, 76.622592),
    zoom: 14.4746,
  );
  @override
  void initState() {
    // TODO: implement initState
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

  void _animateCamera(LatLng _locationdata) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: _locationdata,
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
      markerList[0]=Marker(
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

  Future<void> trackBus() async {
    if (widget.bus != null) {
      Uint8List imageData = await getMarker();
      getBusLoc(widget.bus).listen((snapshot) {
        GeoPoint point = snapshot.data()['points'];
        markerList[1]=Marker(
            markerId: MarkerId("bus"),
            position: LatLng(point.latitude, point.longitude),
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.78, 0.78),
            icon: BitmapDescriptor.fromBytes(imageData));
        _animateCamera(LatLng(point.latitude, point.longitude));
      });
    }
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
       // _showbus(bus);
      },
      label: 'route ' + bus.id.toString(),
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
      labelBackgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bus No.1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Courgette',
            ),),
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [FutureBuilder(
                future: getAllBus(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SpeedDial(
                      animatedIcon: AnimatedIcons.menu_close,
                      animatedIconTheme: IconThemeData(size: 22.0),
                      // child: Icon(Icons.add),
                      onOpen: () => print('OPENING DIAL'),
                      onClose: () => print('DIAL CLOSED'),
                      curve: Curves.bounceIn,
                      children: snapshot.data
                          .map<SpeedDialChild>((bus) => buildSpeedDialChild(bus))
                          .toList(),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
              FloatingActionButton(
                  child: Icon(Icons.add_location),
                  onPressed: () {
                    //getCurrentLocation();
                    setState(() {
                      dropPassengerMarker();
                    });
                  }),

            ],
          ),
        ),
      ),
    );
  }
}

class PassengerLiftedState extends ChangeNotifier{
  List<Bus> busList;

  PassengerLiftedState(){
   initialiseBusList();
  }
  void initialiseBusList()async{
    busList=await getAllBus();
    notifyListeners();
  }

}
