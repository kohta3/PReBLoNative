// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:like_button/like_button.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/StartPage.dart';
import 'package:preblo/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:app_review/app_review.dart';

class firstTabScreen extends StatefulWidget {
  const firstTabScreen(
      {Key? key,
      required this.PlaceName,
      required this.telephoneNumber,
      required this.url,
      required this.infoDetail,
      required this.images,
      required this.recommend,
      required this.infoId,
      required this.open1,
      required this.close1,
      required this.open2,
      required this.close2,
      required this.sunday,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.carPort,
      required this.bicycleParking,
      required this.pref,
      required this.city,
      required this.doNotKnow,
      required this.secondHour,
      required this.vacation,
      required this.UserName,
      required this.CountLike,
      required this.AuthUserLikes,
      required this.AuthUserId,
      required this.accountImage})
      : super(key: key);
  final PlaceName;
  final telephoneNumber;
  final url;
  final infoDetail;
  final images;
  final recommend;
  final infoId;
  final open1;
  final close1;
  final open2;
  final close2;
  final sunday;
  final monday;
  final tuesday;
  final wednesday;
  final thursday;
  final friday;
  final saturday;
  final carPort;
  final bicycleParking;
  final pref;
  final city;
  final doNotKnow;
  final secondHour;
  final vacation;
  final UserName;
  final CountLike;
  final AuthUserLikes;
  final AuthUserId;
  final accountImage;

  @override
  State<firstTabScreen> createState() => _firstTabScreenState();
}

class _firstTabScreenState extends State<firstTabScreen> with RouteAware {
  final GlobalKey shareKey = GlobalKey();
  bool isLikedBool = false;
  bool ads = true;
  bool sendReport = false;
  bool menu = false;
  bool block = false;
  int star = 3;
  int value = math.Random().nextInt(30);
  var urlLink = 'https://www.preblo.site/';

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
            "INSERT INTO likes (information_id,user_id,created_at,updated_at) VALUES ('${informationId}','${widget.AuthUserId}',current_timestamp,current_timestamp)"); //ここでライクが押された時の処理をする
      });
    } else {
      await connection.transaction((ctx) async {
        await ctx.query(
            "DELETE FROM likes WHERE information_id='${informationId}' AND user_id='${widget.AuthUserId}'"); //すでにlikeの場合
      });
    }
    await connection.close();
  }

  Future<void> flag() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    if (widget.AuthUserId != null) {
      await connection.transaction((ctx) async {
        await ctx.query(
            "INSERT INTO report (information_id,created_at) VALUES ('${widget.AuthUserId}',current_timestamp)" //ここでライクが押された時の処理をする
            );
      });
    } else {
      await connection.transaction((ctx) async {
        await ctx.query(
            "INSERT INTO report (information_id,created_at) VALUES ('${0}','current_timestamp')" //ここでライクが押された時の処理をする
            );
      });
    }
    await connection.close();
  }

  FlagDialog() {
    return showDialog(
        context: context,
        builder: (childContext) {
          return SimpleDialog(
              backgroundColor: Colors.blueAccent,
              title: Text('この投稿を報告しますか?'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SimpleDialogOption(
                      onPressed: () async {
                        await flag();
                        setState(() {
                          sendReport = true;
                        });
                        Navigator.pop(childContext);
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return const StartPage();
                          }));
                        });
                      },
                      child: Text("送信する"),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(childContext);
                      },
                      child: Text("やめる"),
                    ),
                  ],
                )
              ]);
        });
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3022328775537673/3265971090'
        : 'ca-app-pub-3022328775537673/3297760685',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  void _requestReview() {
    AppReview.requestReview.then((onValue) {
      print(onValue);
    });
  }

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

  void didPush() async {
    await myBanner.load();
    setState(() {
      ads = false;
    });
    if (value == 30) {
      _requestReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final AdWidget adWidget = AdWidget(ad: myBanner);

    return Scaffold(
        body: ListView(children: [
      Container(
          padding: const EdgeInsets.all(5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${widget.pref}<${widget.city}',
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.accountImage == null
                          ? Icon(
                              Icons.face_outlined,
                              size: 30,
                            )
                          : CachedNetworkImage(
                              imageUrl: '${widget.accountImage}',
                              width: 30,
                              height: 30,
                              fit: BoxFit.fill,
                            ),
                    ),
                    Text(
                      widget.UserName,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          menu = !menu;
                        });
                      },
                      child: Icon(
                        Icons.menu_open,
                        color: Colors.blue,
                      ),
                    ),
                    menu
                        ? TextButton(
                            onPressed: () {
                              print('ブロック');
                              setState(() {
                                block = !block;
                              });
                            },
                            child: block
                                ? Text(
                                    'ブロック中',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text('ブロックしますか?'))
                        : SizedBox.shrink()
                  ],
                )),
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.PlaceName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                )),

//////////////////////////////////////おすすめ度//////////////////////////////////////
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('投稿者のおすすめ度:',
                      style: TextStyle(color: Colors.grey)),
                  for (int i = 1; i <= widget.recommend; i++)
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                  for (int i = 1; i <= 5 - widget.recommend; i++)
                    const Icon(
                      Icons.star_outline,
                      color: Colors.grey,
                    )
                ],
              ),
            ),
//////////////////////////////////////おすすめ度//////////////////////////////////////
//////////////////////////////////////いいね//////////////////////////////////////

            Row(children: [
              const Text('いいね:', style: TextStyle(color: Colors.grey)),
              LikeButton(
                padding: EdgeInsets.all(3),
                likeCount: widget.CountLike,
                mainAxisAlignment: MainAxisAlignment.end,
                isLiked: isLikedBool =
                    widget.AuthUserLikes.contains(widget.infoId),
                onTap: (bool isLiked) async {
                  requestLikes(widget.infoId);
                  isLikedBool = isLiked;
                  return !isLiked;
                },
              ),
              IconButton(
                  onPressed: () async {
                    await Share.share(
                        '${widget.pref}${widget.city}の投稿\nスポット名:${widget.PlaceName}\nandroid > https://bit.ly/3BzfZhX\n ios&web > www.preblo.site\n#旅行 #グルメ #ホテル #PReBLo ');
                  },
                  icon: Icon(Icons.share)),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        FlagDialog();
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Icon(Icons.flag), Text('投稿を報告')]))),
            ]),
            sendReport
                ? Text(
                    '報告が完了しました。ありがとうございます。',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  )
                : SizedBox.shrink(),

//////////////////////////////////////いいね//////////////////////////////////////
//////////////////////////////////////カルーセル//////////////////////////////////////

            RepaintBoundary(
                key: shareKey,
                child: Card(
                    child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          color: Colors.grey[300],
                          child: CarouselSlider(
                            items: [
                              for (var image in widget.images)
                                image != ''
                                    ? Card(
                                        child: CachedNetworkImage(
                                          imageUrl: image,
                                          width: 400,
                                          height: 140,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Card(
                                        child: Container(
                                        width: 400,
                                        height: 140,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.no_photography,
                                            ),
                                            Text('No data')
                                          ],
                                        ),
                                      ))
                            ],
                            options: CarouselOptions(
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 1),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                            ),
                          ),
                        )))),
//////////////////////////////////////カルーセル//////////////////////////////////////

//////////////////////////////////////営業時間//////////////////////////////////////
            Container(
                padding: const EdgeInsets.all(3),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Column(children: [
                  // ignore: prefer_interpolation_to_compose_strings
                  Row(children: [
                    Text(
                      '開いている時間',
                      style: TextStyle(fontSize: 16),
                    ),
                  ]),
                  widget.doNotKnow
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('わかりません'),
                            Icon(Icons.sentiment_dissatisfied)
                          ],
                        )
                      : widget.secondHour
                          ? Text(widget.open1 +
                              '～' +
                              widget.close1 +
                              '   ' +
                              widget.open2 +
                              '～' +
                              widget.close2)
                          : Text(widget.open1 + '～' + widget.close1),

                  ////////////////////////////////ここに時間
                ])),
//////////////////////////////////////営業時間//////////////////////////////////////
//////////////////////////////////////休みの日//////////////////////////////////////
            Row(children: [
              Container(
                  width: screenSize.width * 0.485,
                  height: 60,
                  padding: const EdgeInsets.all(3),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  )),
                  child: Column(children: [
                    // ignore: prefer_interpolation_to_compose_strings
                    Row(
                      children: [
                        Text(
                          '休みの日',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      widget.monday
                          ? const Text('月  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      widget.tuesday
                          ? const Text('火  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      widget.wednesday
                          ? const Text('水  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      widget.thursday
                          ? const Text('木  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      widget.friday
                          ? const Text('金  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      widget.saturday
                          ? const Text('土  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      widget.sunday
                          ? const Text('日',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      widget.vacation
                          ? const Text('無し',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                    ])
                  ])),
//////////////////////////////////////休みの日//////////////////////////////////////
//////////////////////////////////////電話番号//////////////////////////////////////
              Container(
                  width: screenSize.width * 0.485,
                  height: 60,
                  padding: const EdgeInsets.all(3),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  )),
                  child: Column(children: [
                    // ignore: prefer_interpolation_to_compose_strings
                    Row(
                      children: [
                        Text(
                          '電話番号',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(widget.telephoneNumber.toString()),
                    ])
                  ])),
            ]),
//////////////////////////////////////電話番号//////////////////////////////////////
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//////////////////////////////////////リンク///////////////////////////////////////
              (urlLink != '')
                  ? Container(
                      width: screenSize.width * 0.485,
                      height: 60,
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        right: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      )),
                      child: Column(children: [
                        // ignore: prefer_interpolation_to_compose_strings
                        Row(children: [
                          Text(
                            'リンク',
                            style: TextStyle(fontSize: 16),
                          ),
                        ]),
                        InkWell(
                          child: const Text(
                            "ここをタップ",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(widget.url))) {
                              launchUrl(Uri.parse(widget.url));
                            }
                          },
                        ),
                      ]))
                  : const SizedBox.shrink(),
//////////////////////////////////////リンク///////////////////////////////////////
//////////////////////////////////////駐車場///////////////////////////////////////
              Container(
                  width: screenSize.width * 0.485,
                  height: 60,
                  padding: const EdgeInsets.all(3),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Column(children: [
                    // ignore: prefer_interpolation_to_compose_strings
                    Row(children: [
                      Text(
                        '駐車場と駐輪場',
                        style: TextStyle(fontSize: 16),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.bicycleParking
                            ? Row(
                                children: const [
                                  Icon(
                                    Icons.moped,
                                    color: Colors.blue,
                                  ),
                                  Text('有り')
                                ],
                              )
                            : Row(
                                children: const [
                                  Icon(
                                    Icons.moped_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text('無し'),
                                ],
                              ),
                        const SizedBox(
                          width: 20,
                        ),
                        (widget.carPort)
                            ? Row(
                                children: const [
                                  Icon(
                                    Icons.airport_shuttle,
                                    color: Colors.blue,
                                  ),
                                  Text('有り')
                                ],
                              )
                            : Row(
                                children: const [
                                  Icon(
                                    Icons.airport_shuttle_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text('無し'),
                                ],
                              ),
                      ],
                    )
                  ]))
            ]),
//////////////////////////////////////駐車場//////////////////////////////////////
            Container(
                padding: const EdgeInsets.all(3),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Column(children: [
                  // ignore: prefer_interpolation_to_compose_strings
                  Row(children: [
                    Text(
                      '詳細・備考',
                      style: TextStyle(fontSize: 16),
                    ),
                  ]),
                  Wrap(
                    children: [Text(widget.infoDetail)],
                  )
                ])),
          ])),
      ads
          ? SizedBox.shrink()
          : Container(
              alignment: Alignment.center,
              child: adWidget,
              width: myBanner.size.width.toDouble(),
              height: myBanner.size.height.toDouble(),
            ),
    ]));
  }
}
