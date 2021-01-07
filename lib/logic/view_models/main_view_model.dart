import 'dart:async';

import 'package:busbay/logic/Services/auth.dart';
import 'package:busbay/logic/Services/data.dart';
import 'package:busbay/logic/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MainViewModel extends ChangeNotifier {
  PublishSubject<String> status = PublishSubject();
  BehaviorSubject<bool> loading = BehaviorSubject();
  AuthService authService = serviceLocator<AuthService>();

  MainViewModel() {
    loading.add(true);
    Timer(Duration(seconds: 5), () => loading.add(false));
  }

  void onLoginButtonClicked(String email, password) async {
    loading.add(true);
    try {
      await authService.emailSignIn(email, password);
      subscribeToNotification();
    } on FirebaseAuthException catch (e) {
      status.add(e.code);
      loading.add(false);
    }
  }

  void subscribeToNotification() async {
    String uid = authService.getCurrentUserid();
    String route = await getUserRoute(uid);
    String sanitised = route.replaceFirst(RegExp('-'), '');
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.subscribeToTopic(sanitised);
  }
}
