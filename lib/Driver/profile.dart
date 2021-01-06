import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:busbay/drivers_nav.dart';
import 'package:busbay/main.dart';
import 'package:busbay/logic/Services/Model.dart';
import 'package:busbay/logic/Services/user.dart';
import 'package:busbay/logic/Services/users_list.dart';
import 'package:provider/provider.dart';
import 'package:busbay/logic/Services/userData.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Model travel;
  _ProfileScreenState({this.travel});


  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> logOut() async {
    User user = auth.signOut() as User;
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
    if(user==null){
      return Center(child: CircularProgressIndicator());
    }
    return StreamBuilder<UserData>(
      stream:UserService(uid: user.uid).userData,
      builder: (context, snapshot) {
    if(snapshot.hasData) {
      UserData userData = snapshot.data;
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF719F1E),
                  Color(0xFFD5CE58),

                ],
                begin: FractionalOffset.bottomCenter,
                end: FractionalOffset.topCenter,
              ),
            ),
          ),
          Scaffold(
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
                            logOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (BuildContext context) => BNav()));
                          },
                          child: Icon(
                            AntDesign.arrowleft,
                            color: Colors.red,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            logOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (BuildContext context) => App()));
                          },
                          child: Icon(
                            AntDesign.logout,
                            color: Colors.red,
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
                                    color: Color(0xFF212121),
                                  ),
                                  child: Column(
                                    children: [

                                      SizedBox(
                                        height: 80,
                                      ),
                                      Text(
                                        userData.name ?? 'Nill',
                                        style: TextStyle(
                                          color: Color(0xFFD5CE58),
                                          fontFamily: 'Courgette',
                                          fontSize: 35,
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
                                                'Bus Number',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                '1',
                                                style: TextStyle(
                                                  color: Color(0xFFD5CE58),
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