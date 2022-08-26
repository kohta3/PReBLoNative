import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class hotelDetailPage extends StatefulWidget {
  const hotelDetailPage(
      {Key? key,
      required this.large,
      required this.middle,
      required this.small,
      required this.prefecture,
      required this.country})
      : super(key: key);
  final large;
  final middle;
  final small;
  final prefecture;
  final country;

  @override
  State<hotelDetailPage> createState() => _hotelDetailPageState();
}

class _hotelDetailPageState extends State<hotelDetailPage> with RouteAware {
  Map resp = {};
  List hotelBasicInfo = [];
  String? sort;

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
    placeCodeApi();
  }

  Future<void> placeCodeApi() async {
    final url = Uri.parse(
        'https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426?');
    final response = await http.post(url, body: {
      'format': 'json',
      'affiliateId': '20c8801b.9bc4906b.20c8801c.3a69e429',
      'formatVersion': '2',
      'applicationId': '1001393711643575856',
      'largeClassCode': 'japan',
      'middleClassCode': '${widget.middle}',
      'smallClassCode': '${widget.small}',
    });
    resp = jsonDecode(response.body);
    setState(() {
      for (var hotelInfo in resp['hotels']) {
        hotelBasicInfo.add(hotelInfo[0]['hotelBasicInfo']);
      }
    });
    print(hotelBasicInfo[0]);
  }

  Future<void> sortPlace() async {
    hotelBasicInfo = [];
    final url = Uri.parse(
        'https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426?');
    final response = await http.post(url, body: {
      'format': 'json',
      'affiliateId': '20c8801b.9bc4906b.20c8801c.3a69e429',
      'formatVersion': '2',
      'applicationId': '1001393711643575856',
      'largeClassCode': 'japan',
      'middleClassCode': '${widget.middle}',
      'smallClassCode': '${widget.small}',
      'sort': '${sort}'
    });
    setState(() {
      resp = jsonDecode(response.body);
      for (var hotelInfo in resp['hotels']) {
        hotelBasicInfo.add(hotelInfo[0]['hotelBasicInfo']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text('ホテル一覧'),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: screenSize.width * 1,
            color: Colors.brown[100],
            child: Row(children: [
              Container(
                width: screenSize.width * 0.6,
                child: Text(
                    ' 地域 : ' + widget.prefecture + ' -> ' + widget.country),
              ),
              Expanded(
                child: Container(
                  height: 65,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      hint: Text('並び替え', style: TextStyle(fontSize: 12)),
                      items: [
                        DropdownMenuItem(
                          child: Text('おすすめ順', style: TextStyle(fontSize: 12)),
                          value: 'standard',
                        ),
                        DropdownMenuItem(
                          child: Text('安い順', style: TextStyle(fontSize: 12)),
                          value: '+roomCharge',
                        ),
                        DropdownMenuItem(
                          child: Text('高い順', style: TextStyle(fontSize: 12)),
                          value: '-roomCharge',
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          sort = val.toString();
                        });
                        sortPlace();
                      }),
                ),
              )
            ]),
          ),
          for (var Info in hotelBasicInfo)
            Column(children: [
              Container(
                  width: screenSize.width * 1,
                  height: 20,
                  child: Text(
                    Info['hotelName'],
                    overflow: TextOverflow.ellipsis,
                  )),
              Row(children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text('${Info['address1']}${Info['address1']}')),
                Expanded(
                    child: Container(
                  alignment: Alignment.topRight,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(Info['reviewAverage'].toString())
                  ]),
                ))
              ]),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse('${Info['hotelInformationUrl']}'));
                },
                child: CachedNetworkImage(
                  imageUrl: Info['hotelImageUrl'],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  width: screenSize.width * 1,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Row(children: [
                Text('TEL:' + Info['telephoneNo']),
                SizedBox(
                  width: 10,
                ),
                Text('最安値' + Info['hotelMinCharge'].toString() + '円～'),
                SizedBox(
                  width: 10,
                ),
                InkResponse(
                  onTap: () {
                    launchUrl(Uri.parse('${Info['planListUrl']}'));
                  },
                  child: Text(
                    'プラン一覧',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ]),
              Wrap(
                children: [Text(Info['hotelSpecial'])],
              ),
              Container(
                height: 10,
                color: Colors.brown[100],
              )
            ]),
        ],
      ),
    );
  }
}
