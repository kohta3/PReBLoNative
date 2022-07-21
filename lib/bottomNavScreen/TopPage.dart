import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/SearchGenerPage.dart';
import 'package:preblo/SearchPlacePage.dart';
import 'package:like_button/like_button.dart';
import 'package:preblo/main.dart';

import '../submissionDetailsPage.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> with RouteAware {
  int? famous1;
  int? famous2;
  int? famous3;
  int? userId;
  String? uid;
  List newInput = [];
  List famousInput = [];
  List Users = [];
  List authUserLikes = [];
  Map<int, int> sortFamousInput = {};
  bool looding = true;
  bool isLikedBool = false;

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

  Future<void> databasePullData() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> newResults = await connection
        .query("SELECT * FROM information ORDER BY created_at DESC LIMIT 9");
    List<List<dynamic>> famousCount = await connection.query(
        "select information_id, count(information_id) from likes group by information_id Order by count(information_id) DESC");
    List<List<dynamic>> User = await connection.query("SELECT * FROM users");
    List<List<dynamic>> userInfo =
        await connection.query("SELECT id,name FROM users WHERE uid='${uid}'");
    await connection.close();
    return setState(() {
      newInput = newResults;
      Users = User;
      famous1 = famousCount[0][0];
      famous2 = famousCount[1][0];
      famous3 = famousCount[2][0];
      sortFamousInput = {for (var fumus in famousCount) fumus[0]: fumus[1]};
      userId = userInfo[0][0] as int?;
      print('ユーザー情報');
      print(userId);
    });
  }

  Future<void> databasePullSecond() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> famousResults = await connection.query(
        "SELECT * FROM information WHERE id='${famous1}' or id='${famous2}' or id='${famous3}'");
    List<List<dynamic>> userLikes = await connection
        .query("SELECT information_id FROM likes WHERE user_id='${userId}'");
    await connection.close();
    return setState(() {
      famousInput = List.from(famousResults.reversed);
      looding = false;
      for (var userLike in userLikes) {
        authUserLikes.add(userLike[0]);
      }
      print(authUserLikes);
    });
  }

  Future<void> requestLikes(informationId) async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    if (!isLikedBool) {
      await connection.transaction((ctx) async {
        await ctx.query(
            "INSERT INTO likes (information_id,user_id,created_at,updated_at) VALUES ('${informationId}','${userId}',current_timestamp,current_timestamp)"); //ここでライクが押された時の処理をする
      });
    } else {
      await connection.transaction((ctx) async {
        await ctx.query(
            "DELETE FROM likes WHERE information_id='${informationId}' AND user_id='${userId}'"); //すでにlikeの場合
      });
    }
    await connection.close();
  }

  getAuth() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('object');
      } else {
        setState(() {
          uid = user.uid;
        });
      }
    });
  }

  void didPush() async {
    await getAuth();
    await databasePullData();
    await databasePullSecond();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,

      body: looding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 160,
                    height: 100,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.dynamic_feed),
                      label: const Text('ジャンル検索'),
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SearchGenrePage(
                                userId: userId,
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final Offset begin = Offset(-1.0, 0.0); // 左から右
                              final Offset end = Offset.zero;
                              final Animatable<Offset> tween = Tween(
                                      begin: begin, end: end)
                                  .chain(CurveTween(curve: Curves.easeInOut));
                              final Animation<Offset> offsetAnimation =
                                  animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent[100],
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 10.0,
                      maxWidth: 20.0,
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    height: 100,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.maps_home_work),
                      label: const Text('地域で検索'),
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SerchPlacePage(
                                userId: userId,
                              );
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final Offset begin = Offset(1.0, 0.0);
                              final Offset end = Offset.zero;
                              final Animatable<Offset> tween = Tween(
                                      begin: begin, end: end)
                                  .chain(CurveTween(curve: Curves.easeInOut));
                              final Animation<Offset> offsetAnimation =
                                  animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple[200],
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
                ]),

//人気の投稿/////////////////////////////////////////////////////////
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '人気な投稿',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (int i = 0; i < 3; i++)
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey))),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Row(children: [
                                  SizedBox(
                                    width: 7,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image(
                                      image: NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7vC1coMEndWvlJ1uutJSClJLttqq9j2h3VQ&usqp=CAU',
                                      ),
                                      width: 25,
                                      height: 25,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  for (var user in Users)
                                    user[0] == famousInput[i][37]
                                        ? Text(user[1])
                                        : SizedBox.shrink(),
                                  SizedBox(width: 10),
                                  Text(famousInput[i][2])
                                ]),
                              ),
                              Stack(alignment: Alignment.topCenter, children: [
                                Container(
                                  width: screenSize.width * 0.95,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                submissionDetailsPage(
                                                  infoId: famousInput[i][0],
                                                  userId: userId,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      height: 250,
                                      width: screenSize.width * 0.95,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: famousInput[i][10],
                                          width: 400,
                                          height: 140,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: screenSize.width * 0.01,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 3),
                                    child: Icon(
                                      Icons.comment,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: screenSize.width * 0.65,
                                    child: Text(
                                      famousInput[i][1],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                      width: screenSize.width * 0.2,
                                      child: LikeButton(
                                        padding: EdgeInsets.all(3),
                                        likeCount:
                                            sortFamousInput[famousInput[i][0]],
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        isLiked: isLikedBool = authUserLikes
                                            .contains(famousInput[i][0]),
                                        onTap: (bool isLiked) async {
                                          requestLikes(famousInput[i][0]);
                                          isLikedBool = isLiked;
                                          return !isLiked;
                                        },
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
//人気の投稿/////////////////////////////////////////////////////////

//最新の投稿/////////////////////////////////////////////////////////
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '新しい投稿',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < 9; i++)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => submissionDetailsPage(
                                          infoId: newInput[i][0],
                                          userId: userId,
                                        )),
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.all(1),
                                width: screenSize.width * 0.3,
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl: newInput[i][10],
                                            width: screenSize.width * 0.3,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            filterQuality: FilterQuality.low,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7vC1coMEndWvlJ1uutJSClJLttqq9j2h3VQ&usqp=CAU',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                filterQuality:
                                                    FilterQuality.low,
                                              ),
                                            ),
                                            for (var user in Users)
                                              user[0] == newInput[i][37]
                                                  ? Text(
                                                      user[1],
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .withOpacity(
                                                                      0.5)),
                                                    )
                                                  : SizedBox.shrink(),
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: LikeButton(
                                        circleColor: CircleColor(
                                            start: Colors.white,
                                            end: Colors.white),
                                        padding: EdgeInsets.all(3),
                                        likeCount:
                                            sortFamousInput[newInput[i][0]],
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        isLiked: isLikedBool = authUserLikes
                                            .contains(newInput[i][0]),
                                        onTap: (bool isLiked) async {
                                          requestLikes(newInput[i][0]);
                                          isLikedBool = isLiked;
                                          return !isLiked;
                                        },
                                      ),
                                    )
                                  ],
                                )),
                          )
                      ],
                    )),
//最新の投稿/////////////////////////////////////////////////////////
              ],
            ),
    );
  }
}
