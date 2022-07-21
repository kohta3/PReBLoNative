import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preblo/InMyPage/pastPosts.dart';

import '../InMyPage/accountManegment.dart';
import '../NoAuth.dart';
import '../StartPage.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var userState;
  String? uid;
  bool loading = true;

  getAuth() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userState = user;
          loading = false;
          uid = user.uid;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void loginCheck() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.emailVerified);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getAuth();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : userState == null
              ? Center(
                  child: noAuth(),
                )
              : ListView(
                  children: [
                    Column(
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            width: screenSize.width * 1,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey),
                            )),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            passPostsScreen(
                                              uID : uid
                                            )),
                                  );
                                },
                                child: Text(
                                  "過去の投稿",
                                  style: TextStyle(fontSize: 20),
                                ))),
                        Container(
                            alignment: Alignment.topLeft,
                            width: screenSize.width * 1,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey),
                            )),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountManagePage()),
                                  );
                                },
                                child: Text(
                                  "アカウント管理",
                                  style: TextStyle(fontSize: 20),
                                ))),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) {
                                  return const StartPage();
                                }));
                              },
                              child: Text('ログアウト'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(250, 50),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
    );
  }
}
