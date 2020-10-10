import 'package:flutter/material.dart'; 
import 'package:busbay/PBusNo1.dart';

void main() { 
runApp(MaterialApp( 
	home: PLogin(), 
)); 
} 

class PLogin extends StatelessWidget { 
@override 
Widget build(BuildContext context) { 

  Widget textSection = Container(
      
      padding : const EdgeInsets.all(40),
      child:Text('Choose the Bus',
        
        textAlign: TextAlign.start,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
      )
    );
  Row _biuldRow(String busNo , String route, Widget func){ 
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RaisedButton(
          onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder:(context) => func ));
          },
          child:Text(
          busNo,
          ),
          textColor: Colors.white,
          color: Color(0xFF0D47A1), 
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(route),
          )
        ,)
      ],
    ); 
  }




    

  Widget buttonsection=Container(
    child:Row(
      mainAxisAlignment:MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column( 
            children:[
              _biuldRow('1', 'Palakkad -  Trivandrum', PBus1()) ,
              _biuldRow('2', 'Trissur - Kottayam',PBus1()),
              _biuldRow('3', 'Pampady - Pala',PBus1()),
              _biuldRow('4', 'Trivandrum - Kottayam',PBus1()),
              _biuldRow('5', 'Ernakulma - Trissur',PBus1()),
              _biuldRow('6', 'Pampady - Palakkad',PBus1()),
            ]
          ),
        
        )
      ]      
    )
  );


	return Scaffold( 
    drawer: NavDrawer(),
	  appBar: AppBar( 
		  title: Text('Passenger\'s login'), 
		  backgroundColor: Colors.lightBlue, 
	  ), 
	  body:
    Column(
        
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          textSection,
          buttonsection
        ]
      ,)
	); 
} 
} 


class NavDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text('Bus Bay'), 
            accountEmail: Text('mail id'),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: AssetImage('assets/images/example_pic.png') 
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
