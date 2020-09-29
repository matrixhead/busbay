import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Montserrat"),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Text(
                    "BusBay",
                    style: TextStyle(color: Color(0xFFBCE2FAE), fontSize: 30),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(32),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Bingo!!!Save your waiting Time. Sit Back and Relax we will follow your Bus",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFB6AA140), fontSize: 14),
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Center(child: Image.asset("assets/icons/b.png")),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color(0xFFBF1C40F),
                  borderRadius: BorderRadius.circular(54)),
              child: Center(
                child: Text(
                  "Track Bus",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
