import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:postgres/postgres.dart';

import '../main.dart';

class AccountManagePage extends StatefulWidget {
  const AccountManagePage({Key? key}) : super(key: key);

  @override
  State<AccountManagePage> createState() => _AccountManagePageState();
}

class _AccountManagePageState extends State<AccountManagePage> with RouteAware {
  File? _image;
  String? userName;
  String? uid;
  String? authUserName;
  int? userId;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  var AccountImage =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7vC1coMEndWvlJ1uutJSClJLttqq9j2h3VQ&usqp=CAU';

  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  updateUser(name) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await user.updateDisplayName(name);
        await user
            .updatePhotoURL("https://example.com/jane-q-user/profile.jpg");
      }
    });
  }

  getUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userName = user.displayName;
          uid = user.uid;
        });
        getUserId();
      } else {
        print('ok');
      }
      ;
    });
  }

  Future<void> getUserId() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> userInfo =
        await connection.query("SELECT id,name FROM users WHERE uid='${uid}'");
    await connection.close();
    setState(() {
      userId = userInfo[0][0] as int?;
      authUserName = userInfo[0][1];
    });
    print(userId);
  }

  Future<void> RenameUser() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
        "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    await connection.transaction((ctx) async {
      await ctx.query(
          "UPDATE users SET name='${userName}' WHERE id='${userId}'");
    });
    await connection.close();
  }

  void didPush() async {
    await getUser();
  }

  Future _getImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Image.asset('images/logo.png', alignment: Alignment.topRight),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
      ),
      // extendBodyBehindAppBar: true,

      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Image(
                      image: NetworkImage(
                        AccountImage,
                      ),
                      width: 300,
                      height: 300,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: 300,
                    height: 300,
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey.withOpacity(0.5),
                      padding: EdgeInsets.only(bottom: 10),
                      width: 300,
                      height: 60,
                      child: Text(
                        '画像を変更する',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
            onTap: () {
              _getImage();
            },
          ),
          Row(children: [
            SizedBox(
              width: 10,
            ),
            Text('アカウント名')
          ]),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: TextFormField(
              controller: TextEditingController(text: userName),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'アカウント名を入力してください。',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (val) {
                userName = val;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(100),
            child: ElevatedButton(
                onPressed: () {
                  updateUser(userName);
                  RenameUser();
                },
                child: Text('変更を保存')),
          )
        ],
      ),
    );
  }
}
