import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/StartPage.dart';
import 'package:preblo/bottomNavScreen/TopPage.dart';
import 'package:preblo/main.dart';

class afterAddedPage extends StatefulWidget {
  const afterAddedPage({Key? key}) : super(key: key);

  @override
  State<afterAddedPage> createState() => _afterAddedPageState();
}

class _afterAddedPageState extends State<afterAddedPage> with RouteAware {
  int _counter = 3;
  double turns = 0.0;

  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        _counter--;
        setState(() {});
      },
    );
  }

  void _changeRotation1() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() => turns += 1.0/1.0);
    });
  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  autoMove() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return const StartPage();
      }));
    });
  }

  void didPush() async {
    await autoMove();
    _changeRotation1();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
          title: Text('投稿が完了しました'),
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
          ),
          automaticallyImplyLeading: false),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: screenSize.width * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedRotation(
                  turns: turns,
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    Icons.terrain_outlined,
                    size: 100,
                    color: Colors.brown,
                  ),
                ),
                AnimatedRotation(
                  turns: turns,
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    Icons.temple_buddhist_outlined,
                    size: 100,
                    color: Colors.brown,
                  ),
                ),
                AnimatedRotation(
                  turns: turns,
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    Icons.hotel_outlined,
                    size: 100,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            Image(image: AssetImage('images/mark.png'),),
            Text('投稿ありがとうございました。', style: TextStyle(fontSize: 24)),
            Text(_counter.toString() + '秒後にトップページに移動します。')
          ],
        ),
      ),
    );
  }
}
