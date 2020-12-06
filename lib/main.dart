import 'package:busbay/logic/Services/auth.dart';
import 'package:busbay/StudentRegister.dart';
import 'package:busbay/logic/view_models/main_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'logic/Services/data.dart';
import 'logic/Services/auth.dart';
import 'package:busbay/logic/Services/pro.dart';
import 'Passenger_nav.dart';
import 'drivers_nav.dart';
import 'logic/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator();
  runApp(App());
}

class App extends StatelessWidget {
  MainViewModel model = serviceLocator<MainViewModel>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => model, child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().usr,
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Montserrat"),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
         resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                image: AssetImage("assets/icons/e.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: LoginPage(),
          ),
       ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isvalid = false;

  int _pageState = 0;

  //var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFFB40284A);

  double _headingTop = 100;
  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _keyboardVisible = false;
  final emailCntrlr = TextEditingController();
  final passwordCntrlr = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<MainViewModel>(context, listen: false).status.listen((event) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(event),
        ),
      );
      if (event == 'user-not-found' || event == 'wrong-password') {
        setState(() {
          _pageState = 1;
        });
      }
    });
    Provider.of<MainViewModel>(context, listen: false)
        .authService
        .user
        .listen((event) {
      if (event != null) {
        nav(isDriver(event.uid));
      }
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed : $visible");
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    _loginHeight = windowHeight - 270;
    switch (_pageState) {
      case 0:
        //_backgroundColor = Colors.deepPurpleAccent;
        _headingColor = Colors.black87;

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;

        break;
      case 1:
        //_backgroundColor = Colors.deepPurple[600];
        _headingColor = Colors.white;

        _headingTop = 90;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 270;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;

        break;
      case 2:
        //_backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.black;

        _headingTop = 80;

        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _loginYOffset = _keyboardVisible ? 30 : 240;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

        _loginXOffset = 20;

        break;
    }

    return Stack(
      children: <Widget>[
        AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            //color: _backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 0;
                    });
                  },
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        AnimatedContainer(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: Duration(milliseconds: 1000),
                          margin: EdgeInsets.only(
                            top: _headingTop,
                          ),
                          child: Text(
                            "bus Bay",
                            style: TextStyle(
                                color: Color(0xFFf44336),
                                fontSize: 46,
                                fontFamily: 'PermMarker'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "RIT KOTTAYAM",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: _headingColor, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                /*  Container(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Center(
                    child: Image.asset("assets/icons/b.png"),
                  ),
                ), */
                StreamBuilder(
                    stream: Provider.of<MainViewModel>(context, listen: false)
                        .loading,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return Container(
                            margin: EdgeInsets.all(32),
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                           // backgroundColor: Colors.amberAccent ,
                            ));
                      } else {
                        return Container(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_pageState != 0) {
                                  _pageState = 0;
                                } else {
                                  _pageState = 1;
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(32),
                              padding: EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  //color: Color(0xFFFF1744),
                                  color: Color(0xFF304FFE),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: Text(
                                  "track Bus",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    })
              ],
            )),
        AnimatedContainer(
          padding: EdgeInsets.all(32),
          width: _loginWidth,
          height: _loginHeight,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 1000),
          transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(_loginOpacity),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Login To Continue",
                      style: TextStyle(fontSize: 15,
                      color: Colors.black87),
                    ),
                  ),
                  InputWithIcon(
                    icon: Icons.email,
                    hint: "Enter Email...",
                    controller: emailCntrlr,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputWithIcon(
                      icon: Icons.vpn_key,
                      hint: "Enter Password...",
                      controller: passwordCntrlr,
                      obscureText: true)
                ],
              ),
              Column(
                children: <Widget>[
                  Consumer<MainViewModel>(builder: (context, view, child) {
                    return InkWell(
                        onTap: () {
                          isvalid = EmailValidator.validate(emailCntrlr.text);
                          if (isvalid) {
                            view.onLoginButtonClicked(
                                emailCntrlr.text, passwordCntrlr.text);
                            passwordCntrlr.clear();
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => App()));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please Enter a valid Email",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }

                          setState(() {
                            _pageState = 0;
                          });
                        },
                        child: PrimaryButton(
                          btnText: "Login",
                        ));
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterBusBay()));
                        //_pageState = 2;
                      });
                    },
                    child: OutlineBtn(
                      btnText: "Register",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pageState = 0;
                      });
                    },
                    child: OutlineBtn(
                      btnText: "Cancel",
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void nav(Future<bool> driver) {
    driver.then((value) {
      if (value == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => BNav()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => PNav()));
      }
    });
  }
}

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  InputWithIcon({
    this.icon,
    this.hint,
    this.controller,
    this.obscureText = false,
  });

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBC7C7C7), width: 2),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
          Container(
              width: 40,
              child: Icon(
                widget.icon,
                size: 15,
                color: Color(0xFFBB9B9B9),
              )),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                  hintText: widget.hint),
              controller: widget.controller,
              obscureText: widget.obscureText,
            ),
          )
        ],
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final String btnText;
  PrimaryButton({this.btnText});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF304FFE), borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
      ),
    );
  }
}

class OutlineBtn extends StatefulWidget {
  final String btnText;
  OutlineBtn({this.btnText});

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFFFFFF), width: 2),
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(color: Color(0xFFB40284A), fontSize: 12),
        ),
      ),
    );
  }
}
