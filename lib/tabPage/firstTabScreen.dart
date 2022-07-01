// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';

class firstTabScreen extends StatefulWidget {
  final String PlaceName;
  const firstTabScreen({Key? key,required this.PlaceName}) : super(key: key);

  @override
  State<firstTabScreen> createState() => _firstTabScreenState();
}

class _firstTabScreenState extends State<firstTabScreen> {
  int star = 3;
  var businessHoursOpen1 = '10:30';
  var businessHoursClose1 = '15:30';
  var businessHoursOpen2 = '17:30';
  var businessHoursClose2 = '22:30';

  var urlLink = 'https://www.preblo.site/';

  var Monday = true;
  var Tuesday = true;
  var Wednesday = false;
  var Thursday = false;
  var Friday = true;
  var Saturday = false;
  var Sunday = false;

  bool parkingBike = false;
  bool parkingCar = true;

  String tel = '0120 - 00 - 2222';
  String? discription =
      "バイキングは【2部制】にさせていただきます。【1部】17:45-19:15（最終入場18:15）【2部】19:30-21:00（最終入場20:00）ご予約時か前日までにお時間の連絡をお願いいたします。尚、ご連絡がない場合は【1部】でのご案内となります。";

  var imageUrl = [
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
        body: ListView(children: [
      Container(
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  '東京<ところてん',
                )),
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7vC1coMEndWvlJ1uutJSClJLttqq9j2h3VQ&usqp=CAU',),
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Text(
                      'てんのすけ',
                      style: TextStyle(fontSize: 16),
                    )
                  ],)),
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
                  for (int i = 1; i <= star; i++)
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                  for (int i = 1; i <= 5 - star; i++)
                    const Icon(
                      Icons.star_outline,
                      color: Colors.grey,
                    )
                ],
              ),
            ),
//////////////////////////////////////おすすめ度//////////////////////////////////////
//////////////////////////////////////いいね//////////////////////////////////////
           Container(
             child: Row(children: [
               const Text('いいね:',
                   style: TextStyle(color: Colors.grey)),
               const LikeButton(
                   likeCount: 3,
                   mainAxisAlignment: MainAxisAlignment.start),
             ],),
           ),
//////////////////////////////////////いいね//////////////////////////////////////
//////////////////////////////////////カルーセル//////////////////////////////////////
            Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  color: Colors.grey[300],
                  child: CarouselSlider(
                    items: [
                      for (int i = 0; i < 6; i++)
                        Card(
                          child: Image(
                            image: NetworkImage(imageUrl[i]),
                            width: 400,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                )),
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
                      style: TextStyle(
                          backgroundColor: Colors.deepOrange[300],
                          fontSize: 20),
                    ),
                  ]),
                  (businessHoursOpen1 == null)
                      ? Text("  $businessHoursOpen1～$businessHoursClose1")
                      : Text(
                          "  $businessHoursOpen1～$businessHoursClose1   $businessHoursOpen2～$businessHoursClose2"),
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
                          style: TextStyle(
                              backgroundColor: Colors.deepOrange[300],
                              fontSize: 20),
                        )
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      (Monday == true)
                          ? const Text('月  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      (Tuesday == true)
                          ? const Text('火  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      (Wednesday == true)
                          ? const Text('水  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      (Thursday == true)
                          ? const Text('木  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      (Friday == true)
                          ? const Text('金  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      (Saturday == true)
                          ? const Text('土  ',
                              style: TextStyle(decorationColor: Colors.grey))
                          : const SizedBox.shrink(),
                      (Sunday == true)
                          ? const Text('日',
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
                          style: TextStyle(
                              backgroundColor: Colors.deepOrange[300],
                              fontSize: 20),
                        )
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('$tel'),
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
                            style: TextStyle(
                                backgroundColor: Colors.deepOrange[300],
                                fontSize: 20),
                          ),
                        ]),
                        InkWell(
                          child: const Text(
                            "ここをタップ",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(urlLink))) {
                              launchUrl(Uri.parse(urlLink));
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
                        style: TextStyle(
                            backgroundColor: Colors.deepOrange[300],
                            fontSize: 20),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (parkingBike == true)
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
                        (parkingCar == true)
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
                      style: TextStyle(
                          backgroundColor: Colors.deepOrange[300],
                          fontSize: 20),
                    ),
                  ]),
                  Wrap(children: [Text('$discription')],)
                ])),
          ]))
    ]));
  }
}
