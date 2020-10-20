import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
