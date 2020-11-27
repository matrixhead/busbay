import 'package:busbay/logic/view_models/Passenger_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'logic/Services/data.dart';
import 'logic/service_locator.dart';

class passengerspeeddail extends StatefulWidget {
  @override
  passengerspeeddailState createState() => passengerspeeddailState();
}

class passengerspeeddailState extends State<passengerspeeddail>
    with TickerProviderStateMixin,AutomaticKeepAliveClientMixin  {
  MapView mapView = serviceLocator<MapView>();

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
        Provider.of<MapView>(context, listen: false).showbus(bus);
      },
      label: 'route ' + bus.id.toString(),
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
      labelBackgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MapView>(create: (context) => mapView),
      ],
      child: Consumer<MapView>(builder: (context, view, child) {
        return Scaffold(
          body: Scaffold(
            appBar: AppBar(
              title: Text(view.selectedBus?.name ?? "select a bus"),
              backgroundColor: Colors.blue[700],
            ),
            body: GoogleMap(
              mapType: MapType.hybrid,
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
