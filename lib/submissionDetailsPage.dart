import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class submissionDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: NewGradientAppBar(
        title: Image.asset('images/logo.png', alignment: Alignment.topRight),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => submissionDetailsPage()),
              );
            },
            icon: const Icon(Icons.add_box_rounded),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
      ),
      // extendBodyBehindAppBar: true,
      body: Container(
        child: Text('unko'),
      ),
    );
  }
}
