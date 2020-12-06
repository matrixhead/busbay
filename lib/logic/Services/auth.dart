// ignore: unused_import
import 'dart:async';
import 'package:busbay/logic/Services/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:busbay/logic/Services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AuthService extends ChangeNotifier {
  Observable<User> user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService() {
    user = Observable(_auth.authStateChanges());
  }

  Passs _passsFromFirebaseUser(User usr){
    return usr!=null ?Passs(uid: usr.uid) : null;
  }
  Stream<Passs> get usr{
    return _auth.onAuthStateChanged
    .map(_passsFromFirebaseUser);
  }

  Future<UserCredential> emailSignUp(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> emailSignIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  String getCurrentUserid() {
    return _auth.currentUser.uid;
  }
  Future<void> logOut() async {
    return await _auth.signOut();
  }
  Future<bool> validatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;

    var authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult = await firebaseUser
          .reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;
    firebaseUser.updatePassword(password);
  }
}


//final AuthService authService = AuthService();
