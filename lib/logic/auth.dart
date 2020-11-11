// ignore: unused_import
import 'dart:async';

import 'package:busbay/logic/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class AuthService extends ChangeNotifier {
  Observable<User> user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PublishSubject<String> status = PublishSubject();
  BehaviorSubject<bool> loading = BehaviorSubject();

  AuthService() {
    loading.add(true);
    user = Observable(_auth.authStateChanges());
    Timer(Duration(seconds: 5), () => loading.add(false));
  }


  void googleSignIn() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    print("signed in");
  }

  Future<User> emailSignUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      createUserData(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        status.add("weak password");
      } else if (e.code == 'email-already-in-use') {
        status.add("account already exists");
      }
    } catch (e) {
      status.add(e.code);
    }
  }

  Stream<String> get onAuthStateChanged => _auth.authStateChanges().map(
        (User user) => user?.uid,
  );

  Future updateUserName(String name, User currentUser) async {
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();

  }
  Future<User> emailSignIn(String email, String password) async {
    loading.add(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        status.add(e.code);
        loading.add(false);
      } else if (e.code == 'wrong-password') {
        status.add(e.code);
        loading.add(false);
      }
    }
  }

}

//final AuthService authService = AuthService();
