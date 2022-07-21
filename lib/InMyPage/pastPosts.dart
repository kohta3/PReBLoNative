import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/submissionDetailsPage.dart';

import '../main.dart';

class passPostsScreen extends StatefulWidget {
  const passPostsScreen({Key? key, required this.uID}) : super(key: key);
  final uID;

  @override
  State<passPostsScreen> createState() => _passPostsScreenState();
}

class _passPostsScreenState extends State<passPostsScreen> with RouteAware {
  String? uid;
  bool loading = false;
  int? userId;
  List userLikesId = [];
  List info = [];
  List information = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> initGetUserId() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> getUserId = await connection
        .query("SELECT id FROM users WHERE uid='${widget.uID}'");
    await connection.close();
    return setState(() {
      userId = getUserId[0][0];
    });
  }

  Future<void> oldAdd() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> addedInfo = await connection
        .query("SELECT * FROM information WHERE user_id='${userId}' ORDER BY created_at DESC");
    await connection.close();
    return setState(() {
      for (var added in addedInfo) info.add(added);
      for (var added in addedInfo) information.add(added[0]);
      print('会議中です');
      print(info);
      print(information);
    });
  }

  var imageUrl1 = [
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
  ];

  List<DateTime> date = [
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 11),
    DateTime(2022, 10, 12),
    DateTime(2022, 10, 12),
  ];

  void didPush() async {
    await initGetUserId();
    oldAdd();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: NewGradientAppBar(
          title: Text('記録'),
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
          )),
      // extendBodyBehindAppBar: true,

      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //カラム数
        ),
        itemCount: info.length, //要素数
        itemBuilder: (context, index) { return
          Stack(children: [
            GestureDetector(
              child: CachedNetworkImage(
                imageUrl: (info[index][10]),
                width: 400,
                height: 140,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const submissionDetailsPage(
                            infoId: 1,
                            userId: 1,
                          )),
                );
              },
            ),
            Container(
              width: screenSize.width * 1,
              color: Colors.black.withOpacity(0.5),
              child: Text(
                info[index][14].year.toString() +
                    '年' +
                    info[index][14].month.toString() +
                    '月' +
                    info[index][14].day.toString() +
                    '日',
                style: TextStyle(color: Colors.white),
              ),
            )
          ]);
        },
        shrinkWrap: true,
      ),
    );
  }
}
