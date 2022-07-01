// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:http/http.dart' as http;
import 'package:preblo/main.dart';

class secondTabScreen extends StatefulWidget {
  final double Latitude;
  final double Lightness;
  final String PlaceName;

  secondTabScreen(
      {Key? key,
      required this.Latitude,
      required this.Lightness,
      required this.PlaceName})
      : super(key: key);

  @override
  State<secondTabScreen> createState() => _secondTabScreenState();
}

class _secondTabScreenState extends State<secondTabScreen> with RouteAware {
  Map ResponseHotel = {};
  List ResponseHotels = [];
  List<double> ResHotelLat = [];
  List<double> ResHotelLong = [];
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
      'hits': '6',
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
        body: Column(children: [
      Expanded(
        child:Container(
        padding: EdgeInsets.all(1),
        width: screenSize.width * 1,
        height: screenSize.height * 0.5,
        child: FlutterMap(
          options: MapOptions(
            interactiveFlags: InteractiveFlag.drag | InteractiveFlag.flingAnimation | InteractiveFlag.pinchMove | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
            enableScrollWheel: true,
            center: latLng.LatLng(widget.Latitude, widget.Lightness),
            zoom: 13.0,
            maxZoom: 17.0,
            minZoom: 1.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              retinaMode: true,
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                    width: 300,
                    height: 100,
                    point: latLng.LatLng(widget.Latitude, widget.Lightness),
                    builder: (ctx) => Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: NetworkImage(
                                        'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large'),
                                    width: 70,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(widget.PlaceName,
                                      style: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                                ]),
                            GestureDetector(
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.redAccent,
                                size: 45,
                              ),
                            ),
                          ],
                        )),
                for (int i = 0; i < ResHotelLat.length; i++)
                  Marker(
                      width: 300,
                      height: 100,
                      point: latLng.LatLng(ResHotelLat[i], ResHotelLong[i]),
                      builder: (ctx) => Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        ResponseHotels[i]['hotelName']
                                            .toString(),
                                        style: TextStyle(
                                            backgroundColor: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold))
                                  ]),
                              GestureDetector(
                                child: Icon(
                                  Icons.pin_drop,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                              ),
                            ],
                          )),
              ],
            ),
          ],
        ),
      ),),
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
                    Image(
                      image: NetworkImage(ResponsHotel['hotelImageUrl']),
                      width: 400,
                      height: 220,
                      fit: BoxFit.cover,
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
                                      ? Text('?????',style: TextStyle(color: Colors.white),)
                                      : Wrap(
                                          children: [
                                            for (int i = 1; i <= ResponsHotel['reviewAverage'].round();i++)
                                              const Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                              ),
                                            for (int i = 1;i <=5 -ResponsHotel['reviewAverage'].round();i++)
                                              const Icon(
                                                Icons.star_outline,
                                                color: Colors.grey,
                                              )
                                          ],
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
            ),
          ),
        ),
      ])
//////////////////////////////////////カルーセル//////////////////////////////////////
    ]));
  }
}
