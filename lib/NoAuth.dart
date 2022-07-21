import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Auth/LoginPage.dart';

class noAuth extends StatefulWidget {
  const noAuth({Key? key}) : super(key: key);

  @override
  State<noAuth> createState() => _noAuthState();
}

class _noAuthState extends State<noAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(30),
            color: Colors.lightBlueAccent.withOpacity(0.5),
            child: Column(
              children: [
                Image(image: AssetImage('images/logo.png')),
                Text(
                  '本ページを利用する場合は、ログインボタンをタップしてログインしてください。',
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => loginPage()));
                      },
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                        Text('ログイン'),
                      ],)),
                )
              ],
            )));
  }
}
