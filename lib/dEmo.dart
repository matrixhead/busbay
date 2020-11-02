import 'package:flutter/material.dart';

void main() {
  runApp(new StudentRegistration2());
}


class StudentRegistration2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Form validation",
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFFEFEFE),
          fontFamily: "Montserrat",
          textTheme: TextTheme(
            // body: TextStyle(color: Color(0xFF4B4B4B)),
          )),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}

class LoginScreenState extends State <LoginScreen> {
  final _formKey =new GlobalKey<FormState>();
  final _scaffoldKey =new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _name;
  int _value=1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      /* appBar: new AppBar(
          title: new Text("Login"),
         leading: IconButton (icon:Icon(Icons.arrow_back),
             onPressed:() => Navigator.pop(context, false),
         ),

      ), */
      body: new Container(
        padding: const EdgeInsets.all(50.0),
        child: formSetup(context),
      ),
    );
  }

  Widget formSetup(BuildContext context){
    return new Form(
      key: _formKey,
      child: new Column(

        children: <Widget>[
          new TextFormField(
            decoration: InputDecoration(
                hintText: "Your Name",
                labelText: "Full Name"
            ),
            obscureText: true,
            validator: (val){
              if (val.length == 0)
                return "Name field can't be empty";
              /*  else if (val.length <= 5)
                return "Your password should be more then 6 char long"; */
              else
                return null;
            },
            onSaved: (val)=>_name=val,
          ),

          new TextFormField(
            decoration: InputDecoration(
                hintText: "aa@bb.com",
                labelText: "Email"
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (val){
              if (val.length == 0)
                return "Please enter email";
              else if (!val.contains("@rit"))
                return "Please enter valid email";
              else
                return null;
            },
            onSaved: (val)=>_email=val,
          ),

          new TextFormField(
            decoration: InputDecoration(
                hintText: "Password",
                labelText: "Password"
            ),
            obscureText: true,
            validator: (val){
              if (val.length == 0)
                return "Please enter password";
              else if (val.length <= 5)
                return "Your password should be more then 6 char long";
              else
                return null;
            },
            onSaved: (val)=>_password=val,
          ),
          new Container(

            padding: EdgeInsets.all(20.0),
            child: DropdownButton(
                value: _value,
                items: [
                  DropdownMenuItem(
                    child: Text("First Item"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("Second Item"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                      child: Text("Third Item"),
                      value: 3
                  ),
                  DropdownMenuItem(
                      child: Text("Fourth Item"),
                      value: 4
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                }
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          new RaisedButton(
            child: new Text("Submit"),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text("Your email: $_email and Password: $_password"),
                ));
              }
            },
            color: Colors.blue,
            highlightColor: Colors.blueGrey,
          )
        ],
      ),
    );
  }
}