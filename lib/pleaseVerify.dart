import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Auth/VerifyEmail.dart';
import 'StartPage.dart';

class pleaseVerify extends StatefulWidget {
  const pleaseVerify({Key? key}) : super(key: key);

  @override
  State<pleaseVerify> createState() => _pleaseVerifyState();
}

class _pleaseVerifyState extends State<pleaseVerify> {
  String? userName;

  getUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userName = user.displayName;
        });
      };
    });
  }

  updateUser(name) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await user.updateDisplayName(name);
      }});
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return const StartPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '認証を完了してください',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => verifyEmail()),
                  );
                },
                child: Text('認証する')),
            TextButton(
                onPressed: () async {
                  await getUser();
                  await updateUser(userName);
                },
                child: Text('認証済みの方はこちらをタップしてください'))
          ],
        ),
      ),
    );
  }
}
