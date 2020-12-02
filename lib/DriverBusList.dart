// edit need in pubsec.yaml,build,gradle,setting.gradle
import 'package:busbay/logic/Services/data.dart';
import 'package:busbay/logic/service_locator.dart';
import 'package:busbay/logic/view_models/driver_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
      home: driverspeeddail(), title: 'Flutter Speed Dial Examples'));
}

class driverspeeddail extends StatefulWidget {
  @override
  driverspeeddailState createState() => driverspeeddailState();
}

class driverspeeddailState extends State<driverspeeddail>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  DriverMapView mapView = serviceLocator<DriverMapView>();

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
        Provider.of<DriverMapView>(context, listen: false).showbus(bus);
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
        ChangeNotifierProvider<DriverMapView>(create: (context) => mapView)
      ],
      child: Consumer<DriverMapView>(builder: (context, view, child) {
        return Scaffold(
          body: Scaffold(
            appBar: AppBar(
              title: Text(view.selectedBus?.name ?? "select a bus"),
              backgroundColor: Colors.blue[700],
            ),
            body: GoogleMap(
              scrollGesturesEnabled: true,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: view.initialLocation,
              markers: Set.of(view.markerList.values.toList() ?? []),
              circles: Set.of(view.circleList ?? []),
              onMapCreated: view.onMapCreated,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    child: Text("START"),
                    heroTag: "FABstart",
                    onPressed: () {
                      view.getCurrentLocation();
                      view.starttime=view.getTime();
                      print(view.starttime);
                    },
                  ),
                  FloatingActionButton(
                      heroTag: "FABend",
                      child: Text(
                        "END",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'DancingScript',
                        ),
                      ),
                      onPressed: () {
                        view.locationSubscription.cancel();
                        view.endtime=view.getTime();
                        print(view.endtime);
                      })
                ],
              ),
            ),
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
