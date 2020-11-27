import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'userData.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Passs>(context);
    print(user);
    return Container();
  }
}
