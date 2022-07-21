import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/StartPage.dart';
import 'package:preblo/main.dart';

class googleAuthPage extends StatefulWidget {
  const googleAuthPage({Key? key}) : super(key: key);

  @override
  State<googleAuthPage> createState() => _googleAuthPageState();
}

class _googleAuthPageState extends State<googleAuthPage> with RouteAware {
  String? uid;
  String? name;
  String? Email;
  bool loading = true;
  bool error = false;
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> didPush() async {
    await getAuth();
    authGoogleUser();
  }

  Future getAuth() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('google認証エラー＝google認証できていません');
      } else {
        uid = user.uid;
        Email = user.email;
        name = user.displayName;
      }
    });
  }

  Future<void> authGoogleUser() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> firstAuth =
        await connection.query("SELECT id FROM users WHERE uid='${uid}'");
    await connection.close();
    if (firstAuth != '') {
      print('未登録のアカウント');
      print(firstAuth);
      setState(() {
        loading = false;
      });
    } else {
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return const StartPage();
      }));
      print(firstAuth);
    }
  }

  Future<void> databasePush() async {
    try {
      var connection = PostgreSQLConnection(
          "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
          username: "nidpustzmfzulk",
          password:
              "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
          useSSL: true);
      await connection.open();
      await connection.transaction((ctx) async {
        await ctx.query(
            "INSERT INTO users (name,email,password,created_at,updated_at,uid) VALUES ('${name}','${Email}','preblo',current_timestamp,current_timestamp,'${uid}')");
      });
      await connection.close();
    } catch (e) {
      setState((){error = true;});
        var connection = PostgreSQLConnection(
            "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
            username: "nidpustzmfzulk",
            password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
            useSSL: true);
        await connection.open();
        await connection.transaction((ctx) async {
          await ctx.query(
              "UPDATE users SET uid='${uid}' WHERE email='${Email}'");
        });
        await connection.close();
    }
    ;
  }

  updateUser(name) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await user.updateDisplayName(name);
        await Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return const StartPage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: NewGradientAppBar(
          automaticallyImplyLeading: false,
          leading: Icon(Icons.opacity),
          title: Text('google認証'),
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
          ),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: screenSize.width * 0.9,
                    child: Text('ご登録ありがとうございます!'),
                  ),
                  Container(
                    height: 200,
                    child: Image.asset('images/charactor.png'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('下記フォームからユーザー名を登録してください'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      '※ほかの人に表示される名前です',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Center(
                      child: SizedBox(
                    width: screenSize.width * 0.6,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'ユーザー名'),
                      initialValue: name,
                      onChanged: (txt) {
                        name = txt;
                      },
                    ),
                  )),
                  Center(
                    child: Container(
                        padding: EdgeInsets.only(top: 20),
                        width: screenSize.width * 0.5,
                        child: ElevatedButton(
                            onPressed: () async {
                              databasePush();
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return const StartPage();
                              }));
                            },
                            child: Text('保存してトップに戻る'))),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  error
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Text(
                                '登録済みのアカウントです。',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return const StartPage();
                                    }));
                                  },
                                  child: Text('戻る'))
                            ])
                      : SizedBox.shrink(),
                ],
              ));
  }
}
