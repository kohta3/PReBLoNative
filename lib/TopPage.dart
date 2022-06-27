import 'package:flutter/material.dart';
import 'package:preblo/SearchGenerPage.dart';
import 'package:preblo/SearchPlacePage.dart';
import 'package:like_button/like_button.dart';

import 'submissionDetailsPage.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  var imageUrl1 = [
    'https://pbs.twimg.com/media/FTA5xHzVsAAkiZx?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRzvnCJagAAoSU7?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRyc4p8acAAcmq8?format=jpg&name=small'
  ];
  var imageUrl2 = [
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large'
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // extendBodyBehindAppBar: true,

      body: ListView(
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
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const SearchGenrePage();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final Offset begin = Offset(-1.0, 0.0); // 左から右
                        final Offset end = Offset.zero;
                        final Animatable<Offset> tween =
                            Tween(begin: begin, end: end)
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
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const SerchPlacePage();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final Offset begin = Offset(1.0, 0.0);
                        final Offset end = Offset.zero;
                        final Animatable<Offset> tween =
                            Tween(begin: begin, end: end)
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
                    '人気の投稿',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                for (int i = 0; i < 3; i++)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => submissionDetailsPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          height: 180,
                          width: 400,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: NetworkImage(imageUrl1[i]),
                              width: 400,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Wrap(
                        children: [
                          SizedBox(
                            child: Row(children: const [
                              Text("@ユーザー名"),
                              SizedBox(width: 10),
                              Text(
                                "場所の名前",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            ]),
                          ),
                          Row(children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.lightBlueAccent,
                                    width: 3,
                                  ),
                                ),
                              ),
                              width: screenSize.width * 0.8,
                              child: const Text("コメントコメントコメントコメントコメント"),
                            ),
                            const LikeButton(
                                likeCount: 0,
                                mainAxisAlignment: MainAxisAlignment.end),
                          ]),
                          const SizedBox(height: 40),
                        ],
                      )
                    ],
                  ),
              ],
            ),
          ),
//人気の投稿/////////////////////////////////////////////////////////

//最新の投稿/////////////////////////////////////////////////////////
          Container(
            // padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '  最近の投稿',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                for (int i = 0; i < 3; i++)
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(children: [
                      SizedBox(
                        width: screenSize.width * 0.035,
                      ),
                      Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        submissionDetailsPage()),
                              );
                            },
                            child: Image(
                              image: NetworkImage(imageUrl2[i]),
                              width: screenSize.width * 0.45,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: screenSize.width * 0.3,
                                child: Text("@ユーザー名")),
                            const LikeButton(
                                likeCount: 0,
                                mainAxisAlignment: MainAxisAlignment.end),
                          ],
                        ),
                      ]),
                      SizedBox(
                        width: screenSize.width * 0.03,
                      ),
                      Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        submissionDetailsPage()),
                              );
                            },
                            child: Image(
                              image: NetworkImage(imageUrl2[i + 3]),
                              width: screenSize.width * 0.45,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: screenSize.width * 0.3,
                                child: Text("@ユーザー名")),
                            const LikeButton(
                                likeCount: 0,
                                mainAxisAlignment: MainAxisAlignment.end),
                          ],
                        ),
                      ]),
                      SizedBox(
                        width: screenSize.width * 0.035,
                      ),
                    ]),
                  ),
              ],
            ),
          ),
//最新の投稿/////////////////////////////////////////////////////////
        ],
      ),
    );
  }
}
