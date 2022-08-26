import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:preblo/hotel/htoelPage.dart';
import 'package:preblo/main.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class hotelSearchPage extends StatefulWidget {
  const hotelSearchPage({Key? key}) : super(key: key);

  @override
  State<hotelSearchPage> createState() => _hotelSearchPageState();
}

class _hotelSearchPageState extends State<hotelSearchPage> with RouteAware {
  List Title = [];
  List UserReviews = [];
  List UserReview = [];
  List middleClassName = [];
  List hotelImageUrl = [];
  List planListUrl = [];
  List checkAvailableUrl = [];
  List reviewCount = [];
  List reviewAverage = [];
  List res = [];
  List hotelInformationUrl = [];
  List smallPlace = [];
  Map resp = {};
  Map SearchLocate = {};
  String? selectedForPref;
  String? selectedForDetail;
  String? mapKey;
  String? mapVal;
  String? mapSmallKey;
  String? mapSmallVal;

  List<String> selectedRegion = [
    "北海道",
    "東北",
    "関東",
    '北陸',
    "中部",
    "近畿",
    "四国",
    "中国",
    "九州沖縄",
  ];
  Map selectPrefCode = {};

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

  Future<void> hotelSearchApi() async {
    final url = Uri.parse(
        'https://app.rakuten.co.jp/services/api/Travel/HotelRanking/20170426?');
    final response = await http.post(url, body: {
      'formatVersion': '2',
      'affiliateId': '20c8801b.9bc4906b.20c8801c.3a69e429',
      'applicationId': '1001393711643575856',
    });
    res = jsonDecode(response.body)['Rankings'][0]['hotels'];
    setState(() {
      for (var hotel in res) {
        Title.add(hotel['hotelName']);
        UserReviews.add(hotel['userReview']);
        middleClassName.add(hotel['middleClassName']);
        hotelImageUrl.add(hotel['hotelImageUrl']);
        checkAvailableUrl.add(hotel['checkAvailableUrl']);
        reviewCount.add(hotel['reviewCount']);
        reviewAverage.add(hotel['reviewAverage']);
        planListUrl.add(hotel['planListUrl']);
        hotelInformationUrl.add(hotel['hotelInformationUrl']);
      }
      for (var userReview in UserReviews) {
        UserReview.add(userReview.split('<'));
      }
    });
  }

  // // 上の画面がpopされて、この画面に戻ったときに呼ばれます
  // void didPopNext() {
  //   debugPrint("didPopNext ${runtimeType}");
  // }
  //
  // この画面がpushされたときに呼ばれます
  void didPush() {
    hotelSearchApi();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView.builder(
          itemCount: res.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(children: [
              index == 0
                  ? Container(
                      color: Colors.brown[100],
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 40,
                              child: Text('行き先は?'),
                            )
                          ],
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            for (var selected in selectedRegion)
                              Container(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                width: screenSize.width * 0.3,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.pinkAccent.withOpacity(0.5)),
                                    onPressed: () {
                                      setState(() {
                                        selectedForPref = selected;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => hotelPage(
                                                  pref: '$selectedForPref',
                                                )),
                                      );
                                    },
                                    child: Text(selected)),
                              ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 40,
                          child: Text(
                            '人気のホテル10選',
                          ),
                        )
                      ]),
                    )
                  : SizedBox.shrink(),
              Container(
                width: screenSize.width * 1,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey.withOpacity(0.5)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 3,
                    ),
                    Row(children: [
                      Text(
                        (index + 1).toString() + '位',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        middleClassName[index],
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(Title[index]),
                    ]),
                    GestureDetector(
                      onTap: () {
                        launchUrl(
                            Uri.parse('${res[index]['hotelInformationUrl']}'));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: CachedNetworkImage(
                          imageUrl: hotelImageUrl[index],
                          width: screenSize.width * 1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Row(children: [
                      for (int i = 0; i < 5; i++)
                        Icon(
                          Icons.star,
                          color: Colors.purpleAccent,
                        ),
                      InkWell(
                        onTap: () {
                          launchUrl(Uri.parse('${res[index]['planListUrl']}'));
                        },
                        child: Text(
                          'プランを確認する',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ]),
                    ReadMoreText(
                      UserReview[index][0],
                      trimLines: 1,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: '表示する',
                      trimExpandedText: '表示を隠す',
                      lessStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      moreStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )
                  ],
                ),
              ),
              Container(
                height: 20,
                decoration: BoxDecoration(color: Colors.brown[100]),
              )
            ]);
          }),
    );
  }
}
