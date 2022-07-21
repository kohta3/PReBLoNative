import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/Auth/VerifyEmail.dart';

class addDatabaseFromEmail extends StatefulWidget {
  const addDatabaseFromEmail(
      {Key? key, required this.mailAddress, required this.passwordLength})
      : super(key: key);
  final String passwordLength;
  final String mailAddress;
  @override
  State<addDatabaseFromEmail> createState() => _addDatabaseFromEmailState();
}

class _addDatabaseFromEmailState extends State<addDatabaseFromEmail>
    with RouteAware {
  String? name;
  String uid = '';

  updateUser(name) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await user.updateDisplayName(name);
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => verifyEmail()),
        );
      }
    });
  }

  getUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          uid = user.uid;
        });
      } else {
        print('ok');
      }
      ;
    });
  }

  Future<void> databasePush() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    await connection.transaction((ctx) async {
      await ctx.query(
          "INSERT INTO users (name,email,password,created_at,updated_at,uid) VALUES ('${name}','${widget.mailAddress}','preblo',current_timestamp,current_timestamp,'${uid}')");
    });
    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NewGradientAppBar(
          automaticallyImplyLeading: false,
          leading: SizedBox(
            width: 2,
          ),
          title: Text('ユーザー名'),
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(height: 10),
            Text(
              'メールアドレス',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(widget.mailAddress),
            ),
            SizedBox(height: 10),
            Text('パスワード', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < widget.passwordLength.length; i++)
                        Text('※')
                    ])),
            SizedBox(height: 10),
            Text('ユーザー名を入力してください',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: TextFormField(
                decoration: InputDecoration(hintText: '投稿時などに表示される名前です'),
                onChanged: (text) {
                  name = text;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 50, left: 50, top: 50),
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  await getUser();
                  await databasePush();
                  updateUser(name);
                },
                child: Text('OK'),
              ),
            )
          ],
        ));
  }
}
