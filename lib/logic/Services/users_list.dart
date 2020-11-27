import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:busbay/logic/Services/Model.dart';
import 'package:provider/provider.dart';

class usersList extends StatefulWidget {
  @override
  _usersListState createState() => _usersListState();
}

class _usersListState extends State<usersList> {
  @override
  Widget build(BuildContext context) {
    final bb=Provider.of<List<Model>>(context);
   // print(bb.docs);
    bb.forEach((element) {
      print(element.name);
      print(element.email);
      print(element.department);
    });
    return Container();
  }
}
