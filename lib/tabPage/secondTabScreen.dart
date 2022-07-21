// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:http/http.dart' as http;
import 'package:preblo/main.dart';
import 'package:url_launcher/url_launcher.dart';

class secondTabScreen extends StatefulWidget {
  final double Latitude;
  final double Lightness;
  final String PlaceName;
  final String image;

  secondTabScreen(
      {Key? key,
      required this.Latitude,
      required this.Lightness,
      required this.PlaceName,
      required this.image})
      : super(key: key);

  @override
  State<secondTabScreen> createState() => _secondTabScreenState();
}

class _secondTabScreenState extends State<secondTabScreen> with RouteAware {
  Map ResponseHotel = {};
  List ResponseHotels = [];
  List ResponseHotelImages = [];
  List<double> ResHotelLat = [];
  List<double> ResHotelLong = [];
  String reason = '';
  bool isVisible = false;
  String hiden = '非表示';

  final CarouselController _controller = CarouselController();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      reason = changeReason.toString();
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

  Future<void> TravelApi() async {
    final url = Uri.parse(
        'https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426?');
    final response = await http.post(url, body: {
      'format': 'json',
      'affiliateId': '20c8801b.9bc4906b.20c8801c.3a69e429',
      'latitude': widget.Latitude.toString(),
      'longitude': widget.Lightness.toString(),
      'datumType': '1',
      'hits': '10',
      'sort': 'standard',
      'searchRadius': '3',
      'applicationId': '1001393711643575856'
    });
    var res = jsonDecode(response.body);
    print('Response status: ${response.statusCode}');
    return setState(() {
      for (int i = 0; i < res['hotels'].length; i++) {
        print(res['hotels'][i]['hotel'][0]['hotelBasicInfo']['reviewAverage']);
        ResponseHotel = res['hotels'][i]['hotel'][0]['hotelBasicInfo'];
        ResponseHotels.add(res['hotels'][i]['hotel'][0]['hotelBasicInfo']);
        ResHotelLat.add(
            res['hotels'][i]['hotel'][0]['hotelBasicInfo']['latitude']);
        ResHotelLong.add(
            res['hotels'][i]['hotel'][0]['hotelBasicInfo']['longitude']);
        ResponseHotelImages.add(
            res['hotels'][i]['hotel'][0]['hotelBasicInfo']['hotelName']);
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
    TravelApi();
  }
  //
  // // この画面がpopされたときに呼ばれます
  // void didPop() {
  //   debugPrint("didPop ${runtimeType}");
  // }
  //
  // // この画面から新しい画面をpushしたときに呼ばれます
  // void didPushNext() {
  //   debugPrint("didPushNext ${runtimeType}");
  // }

  void hidenContoroller(bools, hidenText) {
    isVisible = bools;
    hiden = hidenText;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(children: [
      Expanded(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: screenSize.width * 1,
              child: FlutterMap(
                options: MapOptions(
                  interactiveFlags: InteractiveFlag.drag |
                      InteractiveFlag.flingAnimation |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom,
                  enableScrollWheel: true,
                  center: latLng.LatLng(widget.Latitude, widget.Lightness),
                  zoom: 13,
                  maxZoom: 17.0,
                  minZoom: 1.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    retinaMode: true,
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                          anchorPos: AnchorPos.align(AnchorAlign.right),
                          width: 300,
                          height: 100,
                          point:
                              latLng.LatLng(widget.Latitude, widget.Lightness),
                          builder: (ctx) => Row(
                                children: [
                                  Icon(
                                    Icons.control_point,
                                    color: Colors.redAccent,
                                    size: 45,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: NetworkImage(widget.image),
                                          width: 70,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(widget.PlaceName,
                                            style: TextStyle(
                                                backgroundColor: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ]),
                                ],
                              )),
                      ...Iterable<int>.generate(ResponseHotels.length).map(
                        (int pageIndex) => Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.right),
                            width: 300,
                            height: 100,
                            point: latLng.LatLng(ResHotelLat[pageIndex],
                                ResHotelLong[pageIndex]),
                            builder: (ctx) => GestureDetector(
                                onTap: () {
                                  _controller.animateToPage(pageIndex);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Colors.blueAccent,
                                      size: 35,
                                    ),
                                    Visibility(
                                      visible: isVisible,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                ResponseHotels[pageIndex]
                                                        ['hotelName']
                                                    .toString(),
                                                style: TextStyle(
                                                    backgroundColor:
                                                        Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ]),
                                    ),
                                  ],
                                ))),
                      ), ////////////////////////////////////////////////////////////hotpapper準備
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.redAccent.withOpacity(0.5))),
                onPressed: () {
                  setState(() {
                    isVisible == false
                        ? hidenContoroller(true, '表示中')
                        : hidenContoroller(false, '非表示');
                  });
                },
                child: Text(hiden),
              ),
            )
          ],
        ),
      ),
//////////////////////////////////////カルーセル//////////////////////////////////////
      Column(children: [
        Container(
          height: screenSize.height * 0.3,
          color: Colors.grey[300],
          child: CarouselSlider(
            items: [
              for (Map ResponsHotel in ResponseHotels)
                Card(
                    child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (await canLaunchUrl(
                            Uri.parse(ResponsHotel['hotelInformationUrl']))) {
                          launchUrl(
                              Uri.parse(ResponsHotel['hotelInformationUrl']));
                        }
                      },
                      child: Image(
                        image: NetworkImage(ResponsHotel['hotelImageUrl']),
                        width: 400,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Wrap(
                          children: [
                            Text(
                              ResponsHotel['hotelName'].toString(),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (ResponsHotel['reviewAverage'] == null)
                                      ? Text(
                                          '?????',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Wrap(
                                          children: [
                                            for (int i = 1;
                                                i <=
                                                    ResponsHotel[
                                                            'reviewAverage']
                                                        .round();
                                                i++)
                                              const Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                              ),
                                            for (int i = 1;
                                                i <=
                                                    5 -
                                                        ResponsHotel[
                                                                'reviewAverage']
                                                            .round();
                                                i++)
                                              const Icon(
                                                Icons.star_outline,
                                                color: Colors.grey,
                                              )
                                          ],
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '最安値',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    ResponsHotel['hotelMinCharge'].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '円から',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                )),
            ],
            options: CarouselOptions(
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: onPageChange,
            ),
            carouselController: _controller,
          ),
        ),
      ]),
//////////////////////////////////////カルーセル//////////////////////////////////////
    ]));
  }
}
