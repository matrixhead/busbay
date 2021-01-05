import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busbay/logic/Services/ChangePassword.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:busbay/logic/Services/user.dart';
import 'package:busbay/logic/Services/userData.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:busbay/main.dart';

class SettingsPassenger extends StatefulWidget {
  @override
  _SettingsPassengerState createState() => _SettingsPassengerState();
}

class _SettingsPassengerState extends State<SettingsPassenger> with AutomaticKeepAliveClientMixin  {
  bool _keyboardVisible = false;
  double windowWidth = 0;
  double windowHeight = 0;
  double _loginYOffset = 0;
  double _loginXOffset = 0;
  bool _dark;

  @override
  void initState() {
    super.initState();
    _dark = false;
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed : $visible");
        });
      },
    );
  }
  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    _loginYOffset = _keyboardVisible ? 40 : 20;
    _loginXOffset = 0;
    void _showChangePassword() {
      showModalBottomSheet(isScrollControlled: true,context: context, builder: (context) {
        return AnimatedContainer(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          width: windowWidth,
          // height: windowHeight,
          height: _keyboardVisible ? windowHeight : windowHeight-350 ,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 1000),
          transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: SettingsForm(),
        );
      });
    }
    final user = Provider.of<Passs>(context);
    if(user==null){
      return Center(child: CircularProgressIndicator());
    }
    super.build(context);
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
                  backgroundColor:Color(0xFFECF87F),
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
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [

                            Color(0xFF3D550C),
                            Color(0xFFECF87F)
                          ],
                          begin: FractionalOffset.bottomCenter,
                          end: FractionalOffset.topCenter,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Color(0xFFECF87F),
                            child: ListTile(
                              onTap: () {
                                //open edit profile
                              },
                              title: Text(
                                userData.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              leading: CircleAvatar(
                                  child: Text(userData.name[0]),
                                backgroundColor: Color(0xFF3D550C),
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
                                    color: Color(0xFF59981A),
                                  ),
                                  title: Text("Change Password"),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () => _showChangePassword(),
                                  //{
                                  //open change password},
                                ),
                                _buildDivider(),
                                ListTile(
                                  leading: Icon(
                                    FontAwesomeIcons.language,
                                    color: Color(0xFF59981A),
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
                                    color: Color(0xFF59981A),
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
                              color: Color(0xFF3D550C),
                            ),
                          ),
                          SwitchListTile(
                            activeColor: Color(0xFF59981A),
                            contentPadding: const EdgeInsets.all(0),
                            value: true,
                            title: Text("Received notification"),
                            onChanged: (val) {},
                          ),
                          SwitchListTile(
                            activeColor: Color(0xFF59981A),
                            contentPadding: const EdgeInsets.all(0),
                            value: true,
                            title: Text("Received Offer Notification"),
                            onChanged: (val) {},
                          ),
                          SwitchListTile(
                            activeColor: Color(0xFF59981A),
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
      color:Color(0xFF59981A),
    );
  }
  bool get wantKeepAlive => true;
}
