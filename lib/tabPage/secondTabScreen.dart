// ignore_for_file: camel_case_types

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class secondTabScreen extends StatefulWidget {
  final double Latitude;
  final double Lightness;
  secondTabScreen({Key? key, required this.Latitude, required this.Lightness})
      : super(key: key);
  @override
  State<secondTabScreen> createState() => _secondTabScreenState();
}

class _secondTabScreenState extends State<secondTabScreen> {
  var star = 4;
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
      Container(
        padding: EdgeInsets.all(1),
        width: screenSize.width * 1,
        height: screenSize.height * 0.5,
        child: FlutterMap(
          options: MapOptions(
            interactiveFlags: InteractiveFlag.all,
            enableScrollWheel: true,
            center: latLng.LatLng(widget.Latitude, widget.Lightness),
            zoom: 15.0,
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
                                  Text('ところてんのすけ',
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
              ],
            ),
          ],
        ),
      ),
//////////////////////////////////////カルーセル//////////////////////////////////////
      Column(children:[
        Container(
        height: screenSize.height * 0.3,
        color: Colors.grey[300],
        child: CarouselSlider(
          items: [
            for (int i = 0; i < 6; i++)
              Card(
                  child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image(
                    image: NetworkImage(imageUrl[i]),
                    width: 400,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                  Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "お店の名前",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
      ),])
//////////////////////////////////////カルーセル//////////////////////////////////////
    ]));
  }
}
