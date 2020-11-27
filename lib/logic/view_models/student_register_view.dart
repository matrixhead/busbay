import 'package:busbay/logic/Services/auth.dart';
import 'package:busbay/logic/Services/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../service_locator.dart';

class StudentRegisterView extends ChangeNotifier {
  AuthService authService = serviceLocator<AuthService>();

  List<Bus> busList;

  String selectedDepartment = 'select your department';
  String selectedRoute = 'select your route';
  String selectedstop = "select your stop";
  String name = "";
  String email = "";
  String password = "";
  Map<String, String> validations = {};

  List<String> busNameList = ["select your route"];
  List<String> selectedRoutestops = ["select your stop"];

  StudentRegisterView() {
    loadBusData();
  }

  void loadBusData() async {
    busList = await getAllBus();
    busList.forEach((element) {
      busNameList.add(element.name);
    });
    selectedRoute = busNameList[0];
    notifyListeners();
  }

  void setStops() {
    if (selectedRoute != "select your route") {
      Bus selectedBus = busList[busNameList.indexOf(selectedRoute) - 1];
      selectedRoutestops =
          ["select your stop"] + selectedBus.stops.keys.toList();
      notifyListeners();
    } else {
      selectedRoutestops = ["select your stop"];
      notifyListeners();
    }
  }

  Future<void> onRegisterButtonPressed() async {
    print(localvalidator());
    if (localvalidator()) {
      try {
        UserCredential UC = await authService.emailSignUp(email, password);
        createUserData(UC.user.uid, email, name, selectedDepartment,
            selectedRoute, selectedstop);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          validations["email"] = "email already in use";
        }
      }
    }
  }

  bool localvalidator() {
    validations = {};
    bool validated;
    RegExp regex = new RegExp(r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$');
    if (!regex.hasMatch(name))
      validations["name"] = 'invalidusername';
    else
      validations["name"] = null;

    validations["selectedDepartment"] =
        selectedDepartment == 'select your department'
            ? 'Mandatory field'
            : null;

    validations["selectedRoute"] =
        selectedRoute == 'select your route' ? 'Mandatory field' : null;

    validations["selectedstop"] =
        selectedstop == 'select your stop' ? 'Mandatory field' : null;

    if (password.length == 0)
      validations["password"] = "Please enter password";
    else if (password.length <= 5)
      validations["password"] = "Your password should be more then 6 char long";
    else
      validations["password"] = null;

    if (email.length == 0)
      validations["email"] = "Please enter email";
    else if (!email.contains("@rit.ac.in"))
      validations["email"] = "Use Your RIT domain email";
    else
      validations["email"] = null;

    validations.forEach((key, value) {
      validated = value == null ? true : false;
    });

    return validated;
  }
}
