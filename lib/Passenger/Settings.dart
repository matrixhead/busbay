import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:busbay/logic/Services/Model.dart';
import 'package:busbay/logic/Services/user.dart';
import 'package:busbay/logic/Services/pro.dart';
import 'package:busbay/logic/Services/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:busbay/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:busbay/logic/Services/auth.dart';

class SettingsPassenger extends StatefulWidget {
  @override
  _SettingsPassengerState createState() => _SettingsPassengerState();
}

class _SettingsPassengerState extends State<SettingsPassenger> {
  bool _dark;

  @override
  void initState() {
    super.initState();
    _dark = false;
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Passs>(context);
    return StreamBuilder<UserData>(
      stream: UserService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;
          return Theme(
            isMaterialAppTheme: true,
            data: ThemeData(
              brightness: _getBrightness(),
            ),
            child: Scaffold(
              backgroundColor: _dark ? null : Colors.grey.shade200,
              appBar: AppBar(
                elevation: 0,
                brightness: _getBrightness(),
                iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
                backgroundColor: Colors.transparent,
                title: Text(
                  'Settings',
                  style: TextStyle(color: _dark ? Colors.white : Colors.black),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.moon),
                    onPressed: () {
                      setState(() {
                        _dark = !_dark;
                      });
                    },
                  )
                ],
              ),
              body: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: Colors.purple,
                          child: ListTile(
                            onTap: () {
                              //open edit profile
                            },
                            title: Text(
                              userData.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: CircleAvatar(
                              //backgroundImage: NetworkImage(avatars[0]),
                              backgroundImage: AssetImage("assets/icons/e.jpg"),
                            ),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.lock_outline,
                                  color: Colors.purple,
                                ),
                                title: Text("Change Password"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  //open change password
                                },
                              ),
                              _buildDivider(),
                              ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.language,
                                  color: Colors.purple,
                                ),
                                title: Text("Change Language"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  //open change language
                                },
                              ),
                              _buildDivider(),
                              ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: Colors.purple,
                                ),
                                title: Text("Change Location"),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  //open change location
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          "Notification Settings",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        SwitchListTile(
                          activeColor: Colors.purple,
                          contentPadding: const EdgeInsets.all(0),
                          value: true,
                          title: Text("Received notification"),
                          onChanged: (val) {},
                        ),
                        SwitchListTile(
                          activeColor: Colors.purple,
                          contentPadding: const EdgeInsets.all(0),
                          value: false,
                          title: Text("Received newsletter"),
                          onChanged: null,
                        ),
                        SwitchListTile(
                          activeColor: Colors.purple,
                          contentPadding: const EdgeInsets.all(0),
                          value: true,
                          title: Text("Received Offer Notification"),
                          onChanged: (val) {},
                        ),
                        SwitchListTile(
                          activeColor: Colors.purple,
                          contentPadding: const EdgeInsets.all(0),
                          value: true,
                          title: Text("Received App Updates"),
                          onChanged: null,
                        ),
                        const SizedBox(height: 60.0),
                      ],
                    ),
                  ),
                  /*  Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
               Positioned(
                  bottom: 00,
                  left: 00,
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.powerOff,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      //log out
                    },
                  ),
                ) */
                ],
              ),
            ),
          );
        }else{
          return LinearProgressIndicator();
        }

      }
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
