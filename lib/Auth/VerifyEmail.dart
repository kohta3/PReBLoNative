import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/StartPage.dart';

import '../main.dart';

class verifyEmail extends StatefulWidget {
  const verifyEmail({
    Key? key,
  }) : super(key: key);
  @override
  State<verifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> with RouteAware {
  var user;
  String? userName;
  String? userId;

  Future sendEmailVerification() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await user.sendEmailVerification();
        for (final providerProfile in user.providerData) {
          // ID of the provider (google.com, apple.cpm, etc.)
          final provider = providerProfile.providerId;

          // UID specific to the provider
          final uid = providerProfile.uid;

          // Name, email address, and profile photo URL
          final name = providerProfile.displayName;
          final emailAddress = providerProfile.email;
          final profilePhoto = providerProfile.photoURL;
          print(emailAddress);
        }
      }
    });
  }

  getUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() async {
          userName = user.displayName;
          userId = user.uid;
        });
      } else {
        print('ok');
      }
      ;
    });
  }

  updateUser(name) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await user.updateDisplayName(name);
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return const StartPage();
        }));
      }
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

  void didPush() async {
    await sendEmailVerification();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NewGradientAppBar(
          automaticallyImplyLeading: false,
          leading: SizedBox(
            width: 2,
          ),
          title: Text('メール認証'),
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(30),
          children: [
            Text(
              '仮登録が完了しました。',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(
              height: 30,
            ),
            Wrap(
              children: [
                Text('ご登録いただいたメールアドレスに認証メールを送信しました。'),
                TextButton(
                    onPressed: () {
                      sendEmailVerification();
                    },
                    child: Text('再送する場合はこちらをタップしてください'))
              ],
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  await getUser();
                  updateUser(userName);
                },
                style: ButtonStyle(),
                child: Text('トップに戻る'),
              ),
            )
          ],
        ));
  }
}
