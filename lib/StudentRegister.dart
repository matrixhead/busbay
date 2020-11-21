import 'package:busbay/logic/service_locator.dart';
import 'package:busbay/logic/view_models/student_register_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'main.dart';

void main() => runApp(RegisterBusBay());

class RegisterBusBay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/e.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: StudentRegi())),
    );
  }
}

class StudentRegi extends StatefulWidget {
  @override
  _StudentRegiState createState() => _StudentRegiState();
}

class _StudentRegiState extends State<StudentRegi> {
  StudentRegisterView studentRegisterView =
      serviceLocator<StudentRegisterView>();

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildNameTF(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Full Name',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // color: Color(0xFF6200EA),
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.assignment_ind_sharp,
                color: Colors.white,
              ),
              hintText: 'Your Name',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
            validator: (val) {
              String validation =
                  Provider.of<StudentRegisterView>(context, listen: false)
                      .validations["name"];
              if (validation != null) {
                return validation;
              }
              return null;
            },
            onChanged: (val) =>
                Provider.of<StudentRegisterView>(context, listen: false).name =
                    val,
          ),
        ),
      ],
    );
  }

  Widget _departmentDropdown(context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            //color: Color(0xFF6200EA),
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: DropdownButtonFormField(
            dropdownColor: Color(0xFF6200EA),
            isExpanded: true,
            decoration: InputDecoration.collapsed(hintText: ''),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            value: Provider.of<StudentRegisterView>(context, listen: false)
                .selectedDepartment,
            icon: Icon(Icons.arrow_drop_down_rounded),
            iconSize: 30,
            iconEnabledColor: Colors.white,
            elevation: 16,
            onChanged: (String newValue) {
              Provider.of<StudentRegisterView>(context, listen: false)
                  .selectedDepartment = newValue;
            },
            validator: (val) {
              String validation =
                  Provider.of<StudentRegisterView>(context, listen: false)
                      .validations["selectedDepartment"];
              if (validation != null) {
                return validation;
              }
              return null;
            },
            items: <String>[
              'select your department',
              'Computer Science',
              'Mechanical',
              'Electrical',
              'Civil'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                //child: Text(value),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _defaultRouteDropdown(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // color: Color(0xFF6200EA),
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: Consumer<StudentRegisterView>(builder: (context, view, child) {
            return DropdownButtonFormField(
              //dropdownColor: Color(0xFF6200EA),
              dropdownColor: Colors.blueGrey,
              isExpanded: true,
              decoration: InputDecoration.collapsed(hintText: ''),

              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              value: view.selectedRoute,
              icon: Icon(Icons.arrow_drop_down_rounded),
              iconSize: 30,
              iconEnabledColor: Colors.white,
              elevation: 16,
              onChanged: (String newValue) {
                view.selectedRoute = newValue;
                view.setStops();
              },
              validator: (val) {
                String validation = view.validations["selectedRoute"];
                if (validation != null) {
                  return validation;
                }
                return null;
              },
              items: view.busNameList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  //child: Text(value),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }

  Widget _defaultStopDropdown(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // color: Color(0xFF6200EA),
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: Consumer<StudentRegisterView>(builder: (context, view, child) {
            return DropdownButtonFormField(
              //dropdownColor: Color(0xFF6200EA),
              dropdownColor: Colors.blueGrey,
              isExpanded: true,
              decoration: InputDecoration.collapsed(hintText: ''),

              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              value: view.selectedstop,
              icon: Icon(Icons.arrow_drop_down_rounded),
              iconSize: 30,
              iconEnabledColor: Colors.white,
              elevation: 16,
              onChanged: (String newValue) {
                view.selectedstop = newValue;
              },
              validator: (val) {
                String validation = view.validations["selectedstop"];
                if (validation != null) {
                  return validation;
                }
                return null;
              },
              items: view.selectedRoutestops
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  //child: Text(value),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmailTF(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            //color: Color(0xFF6200EA),
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
            validator: (val) {
              String validation =
                  Provider.of<StudentRegisterView>(context, listen: false)
                      .validations["email"];
              if (validation != null) {
                return validation;
              }
              return null;
            },
            onChanged: (val) =>
                Provider.of<StudentRegisterView>(context, listen: false).email =
                    val,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            //color: Color(0xFF6200EA),
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
              obscureText: true,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Enter your Password',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                ),
              ),
              validator: (val) {
                String validation =
                    Provider.of<StudentRegisterView>(context, listen: false)
                        .validations["password"];
                if (validation != null) {
                  return validation;
                }
                return null;
              },
              onChanged: (val) =>
                  Provider.of<StudentRegisterView>(context, listen: false)
                      .password = val),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Provider.of<StudentRegisterView>(context, listen: false)
              .onRegisterButtonPressed()
              .then((value) {
            if (_formKey.currentState.validate()) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => App()));
            }
          });

          // if (_formKey.currentState.validate()) {
          //   _formKey.currentState.save();
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (context) => App()));
          //   Fluttertoast.showToast(
          //       msg: 'Registerd Succesfully',
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.BOTTOM,
          //       timeInSecForIos: 1,
          //       backgroundColor: Colors.white,
          //       textColor: Colors.black);
          //   _scaffoldKey.currentState.showSnackBar(new SnackBar(
          //     content: new Text("Username: $_username\n"
          //         "Email: $_email\n"
          //         "Password: $_password\n"
          //         "Department: $dropdownValue\n"),
          //   ));
          //}
          // setState(() {});
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            //color: Color(0xFF6200EA),
            color: Colors.blueGrey,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => App()));
        });
      }, //=> print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already Registered?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      /* body: AnnotatedRegion<SystemUiOverlayStyle>(
       value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), */
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6200EA),
                  Color(0xFF651FFF),
                  Color(0xFF512DA8),
                  Color(0xFF4527A0),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: ChangeNotifierProvider(
                create: (context) => studentRegisterView,
                child: Builder(builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Register Here',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _buildNameTF(context),
                      SizedBox(height: 20.0),
                      _departmentDropdown(context),
                      SizedBox(height: 20.0),
                      _defaultRouteDropdown(context),
                      SizedBox(height: 20.0),
                      _defaultStopDropdown(context),
                      SizedBox(height: 20.0),
                      _buildEmailTF(context),
                      SizedBox(height: 20.0),
                      _buildPasswordTF(context),
                      _buildSignUpBtn(context),
                      _buildLoginBtn(),
                    ],
                  );
                }),
              ),
            ),
          )
        ],
        //),
        //),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////

// Widget _buildForgotPasswordBtn() {
//   return Container(
//     alignment: Alignment.centerRight,
//     child: FlatButton(
//       onPressed: () => print('Forgot Password Button Pressed'),
//       padding: EdgeInsets.only(right: 0.0),
//       child: Text(
//         'Forgot Password?',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'OpenSans',
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildRememberMeCheckbox() {
//   return Container(
//     height: 20.0,
//     child: Row(
//       children: <Widget>[
//         Theme(
//           data: ThemeData(unselectedWidgetColor: Colors.white),
//           child: Checkbox(
//             value: _rememberMe,
//             checkColor: Colors.green,
//             activeColor: Colors.white,
//             onChanged: (value) {
//               setState(() {
//                 _rememberMe = value;
//               });
//             },
//           ),
//         ),
//         Text(
//           'Remember me',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildSocialBtnRow() {
//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 30.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         _buildSocialBtn(
//               () => print('Login with Facebook'),
//           AssetImage(
//             'assets/icons/b.png',
//           ),
//         ),
//         _buildSocialBtn(
//               () => print('Login with Google'),
//           AssetImage(
//             'assets/icons/b.png',
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildSignInWithText() {
//   return Column(
//     children: <Widget>[
//       Text(
//         '- OR -',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       SizedBox(height: 20.0),
//       Text(
//         'Sign in with',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'OpenSans',
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildSocialBtn(Function onTap, AssetImage logo) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       height: 60.0,
//       width: 60.0,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             offset: Offset(0, 2),
//             blurRadius: 6.0,
//           ),
//         ],
//         image: DecorationImage(
//           image: logo,
//         ),
//       ),
//     ),
//   );
// }
