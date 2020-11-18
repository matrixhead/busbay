
import 'package:busbay/logic/Services/data.dart';
import 'package:flutter/foundation.dart';

class StudentRegisterView extends ChangeNotifier{
  List<String> busnameList = ["Route"];
  String defaultRouteDropdownValue = 'Route';


  StudentRegisterView(){
    loadBusData();
  }

  void loadBusData() async {
    List<Bus> busList = await getAllBus();
    busList.forEach((element) {busnameList.add(element.name);});
    defaultRouteDropdownValue=busnameList[0];
    notifyListeners();
  }

}