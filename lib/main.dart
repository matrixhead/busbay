import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:busbay/DriverBusList.dart';
import 'package:busbay/PassengerBusList.dart';
void main() {
  runApp(MyApp());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        return Text("i guess we need a splash screen here");
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Montserrat"),
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: LoginPage(),
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
  int _pageState = 0;
  var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFF000000);
  double _headingTop = 100;
  double _loginWidth = 0;
  double _loginYOFFset = 0;
  double _loginXOFFset = 0;
  double _registerYOFFset = 0;
  double windowWidth = 0;
  double windowHeight = 0;
  double _loginOpacity = 1;
  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    switch (_pageState) {
      case 0:
        _backgroundColor = Colors.white;
        _headingColor = Color(0xFF000000);
        _headingTop = 100;
        _loginOpacity = 1;
        _loginWidth = windowWidth;
        _loginYOFFset = windowHeight;
        _loginXOFFset = 0;
        _registerYOFFset = windowHeight;
        break;
      case 1:
        _backgroundColor = Color(0xFFB034C50);
        _headingColor = Colors.white;
        _headingTop = 90;
        _loginOpacity = 1;
        _loginWidth = windowWidth;
        _loginYOFFset = 270;
        _loginXOFFset = 0;
        _registerYOFFset = windowHeight;
        break;
      case 2:
        _backgroundColor = Color(0xFFB034C50);
        _headingColor = Colors.white;
        _headingTop = 80;
        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;
        _loginYOFFset = 240;
        _loginXOFFset = 20;
        _registerYOFFset = 270;
        break;
    }
    /* final mediaQueryData = MediaQuery.of(context);
    if (mediaQueryData.orientation == Orientation.landscape) {
      return const Text('landscape');
    }
    return const Text('portrait'); */
    // ignore: dead_code
    return Stack(
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(microseconds: 1000),
          color: _backgroundColor,
          //color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //runSpacing: 12,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _pageState = 0;
                  });
                },
                child: Container(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(milliseconds: 1000),
                        margin: EdgeInsets.only(
                          top: _headingTop,
                        ),
                        child: Text(
                          "BusBay",
                          style:
                              TextStyle(color: Color(0xFF880E4F), fontSize: 25),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "Bingo!!!Save your waiting Time. Sit Back and Relax we will follow your Bus",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: _headingColor,
                                //color: Color(0xFF000000),
                                fontSize: 12),
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Center(child: Image.asset("assets/icons/b.png")),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_pageState != 0) {
                        _pageState = 0;
                      } else {
                        _pageState = 1;
                      }
                    });//navigation link to drivers bus list here
                    Navigator.push(context, MaterialPageRoute(builder:(context) => PLogin()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(32),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xFFFF1744),
                        borderRadius: BorderRadius.circular(54)),
                    child: Center(
                      child: Text(
                        "Track Bus",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                _pageState = 2;
              });
            },
            child: AnimatedContainer(
              padding: EdgeInsets.all(32),
              width: _loginWidth,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              transform:
                  Matrix4.translationValues(_loginXOFFset, _loginYOFFset, 1),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_loginOpacity),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  PrimaryButton(
                    btnText: "Login",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineBtn(
                    btnText: "Create Aaccount",
                  )
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _pageState = 1; //sigup
              });
            },
            child: AnimatedContainer(
              padding: EdgeInsets.all(32),
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              transform: Matrix4.translationValues(0, _registerYOFFset, 0),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  PrimaryButton(
                    btnText: "Create Aaaaccount",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineBtn(
                    btnText: "Back to login",
                  )
                ],
              ),
            )),
      ],
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
          color: Color(0xFF6200EA), borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.all(20),
      child: Center(
          child: Text(
        widget.btnText,
        style: TextStyle(color: Colors.white, fontSize: 16),
      )),
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
          border: Border.all(color: Color(0xFFB40284A), width: 2),
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(color: Color(0xFFB40284A), fontSize: 16),
        ),
      ),
    );
  }
}
