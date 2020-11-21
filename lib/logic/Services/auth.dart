// ignore: unused_import
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AuthService extends ChangeNotifier {
  Observable<User> user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService() {
    user = Observable(_auth.authStateChanges());
  }

  Future<UserCredential> emailSignUp(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future updateUserName(String name, User currentUser) async {
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }

  Future<void> emailSignIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  String getCurrentUserid() {
    return _auth.currentUser.uid;
  }
}

//final AuthService authService = AuthService();
