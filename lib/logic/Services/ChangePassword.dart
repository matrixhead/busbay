import 'package:flutter/material.dart';
import 'user.dart';
import 'package:busbay/logic/service_locator.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  var _passwordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();

//  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool checkCurrentPasswordValid = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(32),
                child: Column(

                  children: <Widget>[
                    Text(
                      'Update Password',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Current Password",
                        errorText: checkCurrentPasswordValid
                            ? null
                            : "Please double check your current password",
                      ),
                      controller: _passwordController,
                      validator: (value) {
                        return checkCurrentPasswordValid
                           ? null
                         : "Please double check your current password";
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "New Password",
                      ),
                      controller: _newPasswordController,
                      obscureText: true,

                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Confirm New Password",
                      ),
                      controller: _repeatPasswordController,
                      validator: (value) {
                        return _newPasswordController.text == value
                            ? null
                            : "Give same as New Password";
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 50.0),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          var userController = serviceLocator.get<UserService>();

                          checkCurrentPasswordValid =
                          await userController.validateCurrentPassword(
                              _passwordController.text);
                          setState(() {});

                          if (_formKey.currentState.validate() &&
                              checkCurrentPasswordValid) {
                            userController.updateUserPassword(
                                _newPasswordController.text);
                            Navigator.pop(context);
                          }

                        }
                    ),
                  ],
                ),
              ),
            );
  }
}