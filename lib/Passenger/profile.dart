import 'package:busbay/logic/Services/userData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:busbay/Passenger_nav.dart';
import 'package:busbay/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:busbay/logic/Services/auth.dart';
import 'package:busbay/logic/Services/Model.dart';
import 'package:busbay/logic/Services/user.dart';
import 'package:busbay/logic/Services/users_list.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProScreen createState() => ProScreen();
}
class ProScreen extends State {

  final Model travel;
  ProScreen({this.travel});


  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logOut() async {
    FirebaseUser user = _auth.signOut() as FirebaseUser;
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    final user = Provider.of<Passs>(context);
    return StreamBuilder<UserData>(
      stream: UserService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData =snapshot.data;
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(4, 9, 35, 1),
                      Color.fromRGBO(39, 105, 171, 1),
                    ],
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                  ),
                ),
              ),
              StreamProvider<List<Model>>.value(
                value: UserService().pass,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //  logOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (BuildContext context) => PNav()));
                                },
                                child: Icon(
                                  AntDesign.arrowleft,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //logOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (BuildContext context) => App()));
                                },
                                child: Icon(
                                  AntDesign.logout,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'My\nProfile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontFamily: 'NiseBuschGardens',
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Container(
                            height: height * 0.43,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double innerHeight = constraints.maxHeight;
                                double innerWidth = constraints.maxWidth;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(

                                        height: innerHeight * 0.72,
                                        width: innerWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 80,
                                            ),
                                            usersList(),
                                                Text(
                                                    userData.name,
                                            style: TextStyle(
                                              color: Color.fromRGBO(39, 105, 171, 1),
                                              fontFamily: 'Courgette',
                                              fontSize: 37,
                                            ),
                                          ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      userData.email,
                                                      //'Department',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontFamily: 'Montserrat',
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      userData.department ?? 'Nill',
                                                      //'MCA',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            39, 105, 171, 1),
                                                        fontFamily: 'Montserrat',
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                /*      Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 25,
                                                  vertical: 8,
                                                ),
                                                child: Container(
                                                  height: 50,
                                                  width: 3,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(20),
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ), */
                                                /*   Column(
                                                children: [
                                                  Text(
                                                    'Bus Route',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                  Text(
                                                    '1',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          39, 105, 171, 1),
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ],
                                              ), */
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 110,
                                      right: 20,
                                      child: Icon(
                                        AntDesign.setting,
                                        color: Colors.grey[700],
                                        size: 30,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          child: Image.asset(
                                            'assets/icons/b.png',
                                            width: innerWidth * 0.45,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }else{
          return CircularProgressIndicator();
        }

      }
    );
  }
}