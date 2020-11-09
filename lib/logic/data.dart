import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:location_platform_interface/location_platform_interface.dart';

class BBUser {
  final String email;
  final String id;
  final int role;

  BBUser({this.id, this.email, this.role});

  BBUser.fromSnapShot(DocumentSnapshot snapshot)
      : id = snapshot.data()['uid'],
        email = snapshot.data()['email'],
        role = snapshot.data()['role'];
}

class Bus {
  final int id;
  final String name;
  final String docID;
  final Map<String, dynamic> status;
  final DocumentReference driver;
  final Map<String, dynamic> stops;

  Bus.fromSnapShot(DocumentSnapshot snapshot)
      : docID=snapshot.id,
        id = snapshot.data()['id'],
        name = snapshot.data()['name'],
        status = snapshot.data()['status'],
        driver = snapshot.data()['driver'],
        stops = snapshot.data()['stops'];
}

void createUserData(User user) async {
  DocumentReference ref =
      FirebaseFirestore.instance.collection('users').doc(user.uid);

  return ref.set({'uid': user.uid, 'email': user.email, 'role': 2},
      SetOptions(merge: true));
}

Future<bool> isDriver(String uid) async {
  int role = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) => BBUser.fromSnapShot(value).role);
  return (role == 1) ? true : false;
}

Future<List<Bus>> getAllBus() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('buses').get();
  return snapshot.docs.map((doc) => Bus.fromSnapShot(doc)).toList();
}

void updateBusLocation(Bus bus, LocationData newLocalData) async{
  DocumentReference ref =
  FirebaseFirestore.instance.collection("buses/"+bus.docID+"/locationPool").doc("currentlocation");
  ref.set({
    'points':GeoPoint(newLocalData.latitude, newLocalData.longitude),
    'heading':newLocalData.heading
  });
}

Stream getBusLoc(Bus bus){
 CollectionReference ref = FirebaseFirestore.instance.collection("buses/"+bus.docID+"/locationPool");
 return ref.doc("currentlocation").snapshots();
}
