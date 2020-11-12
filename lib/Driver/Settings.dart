import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:busbay/main.dart';

class SettingsPassenger extends StatelessWidget {
  FirebaseAuth auth=FirebaseAuth.instance;
  Future<void>logOut() async{
    FirebaseUser user= auth.signOut() as FirebaseUser;
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RaisedButton(
        onPressed: (){
          logOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => App()));
        },
        color: Colors.black,
        child: Text(
          'LOG OUT',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),

    );
  }
}
