// edit need in pubsec.yaml,build,gradle,setting.gradle
import 'package:flutter/material.dart'; 
import 'package:busbay/DBusNo1.dart';

void main() { 
runApp(MaterialApp( 
	home: DBusList(), 
)); 
} 

class DBusList extends StatelessWidget { 
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
              _biuldRow('1', 'Palakkad -  Trivandrum', DBus1()) ,
              _biuldRow('2', 'Trissur - Kottayam',DBus1()),
              _biuldRow('3', 'Pampady - Pala',DBus1()),
              _biuldRow('4', 'Trivandrum - Kottayam',DBus1()),
              _biuldRow('5', 'Ernakulma - Trissur',DBus1()),
              _biuldRow('6', 'Pampady - Palakkad',DBus1()),
            ]
          ),
        
        )
      ]      
    )
  );


	return Scaffold( 
    
	  
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


