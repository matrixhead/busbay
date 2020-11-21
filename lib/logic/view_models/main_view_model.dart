import 'dart:async';

import 'package:busbay/logic/Services/auth.dart';
import 'package:busbay/logic/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

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
    } on FirebaseAuthException catch (e) {
      status.add(e.code);
      loading.add(false);
    }
  }
}
