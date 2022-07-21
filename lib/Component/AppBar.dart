import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../SettingScreen.dart';

class appBarComp extends StatefulWidget {
  final tittle;
  appBarComp({Key? key, @required this.tittle}) : super(key: key);

  @override
  State<appBarComp> createState() => _appBarCompState();
}

class _appBarCompState extends State<appBarComp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NewGradientAppBar(
      title: Text(widget.tittle),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ],
      gradient: LinearGradient(
        colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
      ),
    ));
  }
}
