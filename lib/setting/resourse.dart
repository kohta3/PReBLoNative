import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class resources extends StatefulWidget {
  const resources({Key? key}) : super(key: key);

  @override
  State<resources> createState() => _resourcesState();
}

class _resourcesState extends State<resources> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Image.asset('images/logo.png', alignment: Alignment.topRight),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
      ),
      // extendBodyBehindAppBar: true,

      body: Column(
        children: [
          Container(
              width: screenSize.width * 1,
              height: 50,
              child: Column(
                children: [Text('Ver:1.0'), Text('・アプリ配信開始')],
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              )),
        ],
      ),
    );
  }
}
