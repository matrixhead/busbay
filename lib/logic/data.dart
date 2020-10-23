import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
  final Map<String, dynamic> status;
  final DocumentReference driver;
  final Map<String, dynamic> stops;

  Bus.fromSnapShot(DocumentSnapshot snapshot)
      : id = snapshot.data()['id'],
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

void createBus(String email) async {
  //dummy data
  DocumentReference bus =
      FirebaseFirestore.instance.collection('buses').doc("kl-01-ab-123");
  bus.set({
    'id':2,
    'name': 'kottayam - pala',
    'status': {
      'driverin': true,
      'maintainence': false,
      'running': true,
    },
    'driver': FirebaseFirestore.instance
        .collection('users')
        .doc('MIBjssDxcRRTVD3HhTlhodR73Q83'),
    'stops': {
      'stop1': GeoPoint(9.577142, 76.622592),
      'stop2': GeoPoint(0, 0),
      'stop3': GeoPoint(0, 0)
    }
  });
  bus
      .collection('locationPool')
      .doc('currentlocation')
      .set({'points': GeoPoint(0, 0)});
}

Future<List<Bus>> getAllBus() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('buses').get();
  return snapshot.docs.map((doc) => Bus.fromSnapShot(doc)).toList();
   }
