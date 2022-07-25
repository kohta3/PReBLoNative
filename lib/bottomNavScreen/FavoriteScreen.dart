import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/submissionDetailsPage.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../NoAuth.dart';
import '../main.dart';
import '../pleaseVerify.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with RouteAware {
  var userState;
  String? uid;
  int? userId;
  bool notVerifyEmail = false;
  bool loading = true;
  bool listBool = true;
  bool _visible = false;
  List userLikesId = [];
  List getInfo = [];
  List getDetailInfo = [];
  late final MapController mapController;
  List<String> tsets = [
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
  ];
  List<String> images = [
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
  ];
  List<String> playLists = ['今度行く場所', '温泉', '観光'];
  String selectPlayList = '';
  double Lat = 35.170915;
  double Long = 136.881537;
  List<double> LatList = [35.2, 35.3, 35.4];
  List<double> LngList = [136.80, 136.90, 136.70];
  String _location = "no data";

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

  void getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = position.toString();
        Lat = position.latitude;
        Long = position.longitude;
        mapController.move(latLng.LatLng(Lat, Long), 8);
      });
    } catch (e) {
      print(e);
    }
  }

  getAuth() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          notVerifyEmail = user.emailVerified;
          userState = user;
          loading = false;
          uid = user.uid;
          print(notVerifyEmail);
        });
      }
    });
  }

  Future<void> initGetUserId() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> getUserId =
        await connection.query("SELECT id FROM users WHERE uid='${uid}'");
    List<List<dynamic>> userLikse = await connection.query(
        "SELECT information_id FROM likes WHERE user_id='${getUserId[0][0]}'");
    await connection.close();
    return setState(() {
      userId = getUserId[0][0];
      for (var userLike in userLikse) userLikesId.add(userLike[0]);
      print(userLikesId);
    });
  }

  Future<void> getLikesItem() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    for (int i = 0; i < userLikesId.length; i++)
      getInfo.add(await connection
          .query("SELECT * FROM information WHERE id='${userLikesId[i]}'"));
    await connection.close();
    return setState(() {
      listBool = false;
      for (var get in getInfo) getDetailInfo.add(get[0]);
      print(getDetailInfo);
    });
  }

  @override
  void didPush() async {
    mapController = MapController();
    await getAuth();
    await initGetUserId();
    getLikesItem();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final controller = AutoScrollController();
    return Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : userState == null
                ? Center(
                    child: noAuth(),
                  )
                : notVerifyEmail
                    ? Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: screenSize.height * 0.5,
                                child: FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                      interactiveFlags: InteractiveFlag.drag |
                                          InteractiveFlag.flingAnimation |
                                          InteractiveFlag.pinchMove |
                                          InteractiveFlag.pinchZoom |
                                          InteractiveFlag.doubleTapZoom,
                                      enableScrollWheel: true,
                                      center: latLng.LatLng(Lat, Long),
                                      zoom: 7.0,
                                      maxZoom: 25.0,
                                      minZoom: 1.0,
                                    ),
                                    layers: [
                                      TileLayerOptions(
                                        urlTemplate:
                                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                        subdomains: ['a', 'b', 'c'],
                                        retinaMode: true,
                                      ),
                                      MarkerLayerOptions(markers: [
                                        for (int i = 0 ; i < getDetailInfo.length;i++)
                                          Marker(
                                              anchorPos: AnchorPos.align(
                                                  AnchorAlign.right),
                                              width: screenSize.width * 0.6,
                                              point: latLng.LatLng(
                                                  getDetailInfo[i][28], getDetailInfo[i][29]),
                                              builder: (ctx) => GestureDetector(
                                                    onTap: () {
                                                      controller.scrollToIndex(
                                                        i,
                                                        preferPosition:
                                                            AutoScrollPosition
                                                                .begin,
                                                      );
                                                    },
                                                    child: Row(children: [
                                                      Icon(
                                                        Icons.place,
                                                        color: Colors.redAccent,
                                                      ),
                                                      Visibility(
                                                        visible: _visible,
                                                        child: Text(getDetailInfo[i][2]),
                                                      )
                                                    ]),
                                                  )),
                                      ])
                                    ]),
                              ),
                              Container(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _visible = !_visible;
                                            });
                                          },
                                          child: Text('表示切替'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(12),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FloatingActionButton(
                                        child: Icon(Icons.my_location),
                                        onPressed: () {
                                          getLocation();
                                        },
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                          Expanded(
                              child: listBool
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ListView.builder(
                                      controller: controller,
                                      itemCount: getDetailInfo.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return AutoScrollTag(
                                          key: ValueKey(index),
                                          controller: controller,
                                          index: index,
                                          child: GestureDetector(
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: getDetailInfo[index]
                                                      [10],
                                                  width: screenSize.width * 0.4,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(getDetailInfo[index]
                                                            [3] +
                                                        '>' +
                                                        getDetailInfo[index]
                                                            [4]),
                                                    Text(getDetailInfo[index]
                                                        [2]),
                                                  ],
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        submissionDetailsPage(
                                                          infoId: getDetailInfo[
                                                              index][0],
                                                          userId: userId,
                                                        )),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    )),
                        ],
                      )
                    : Center(child: pleaseVerify()));
  }
}
