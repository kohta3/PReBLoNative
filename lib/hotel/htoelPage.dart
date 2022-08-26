import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/hotel/hotelDetailPage.dart';
import 'package:preblo/main.dart';
import 'package:url_launcher/url_launcher.dart';

class hotelPage extends StatefulWidget {
  const hotelPage({Key? key, required this.pref}) : super(key: key);
  final pref;
  @override
  State<hotelPage> createState() => _hotelPageState();
}

class _hotelPageState extends State<hotelPage> with RouteAware {
  Map smallPlace = {};
  Map resp = {};
  Map SearchLocate = {};
  Map selectPrefCode = {};
  List keys = [];
  String? selectedPrefVal;
  String? selectedPrefKey;
  String? selectedForDetail;
  String? mapKey;
  String? mapVal;
  String? mapSmallKey;
  String? mapSmallVal;
  String? selectedName;
  Map selectedPrefs = {
    "北海道": ["北海道"],
    "東北": ["青森県", "秋田県", "岩手県", "宮城県", "山形県", "福島県"],
    "関東": ['東京都', '千葉県', '埼玉県', '神奈川県', '群馬県', '栃木県', '茨城県', '山梨県'],
    "北陸": ['福井県', '石川県', '富山県', '新潟県'],
    "中部": ['山梨県', '静岡県', '岐阜県', '愛知県'],
    "近畿": ['三重県', '滋賀県', '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県'],
    "四国": ['徳島県', '香川県', '愛媛県', '高知県'], //34
    "中国": ['鳥取県', '島根県', '岡山県', '広島県', '山口県'],
    "九州沖縄": ['福岡県', '大分県', '佐賀県', '長崎県', '熊本県', '宮崎県', '鹿児島県', '沖縄県'],
  };

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
        'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024?');
    final response = await http.post(url, body: {
      'format': 'json',
      'formatVersion': '2',
      'applicationId': '1001393711643575856',
    });
    resp = jsonDecode(response.body);
    for (int i = 0;
        i < resp['areaClasses']['largeClasses'][0][1]['middleClasses'].length;
        i++) {
      smallPlace = {};
      mapKey = resp['areaClasses']['largeClasses'][0][1]['middleClasses'][i]
          ['middleClass'][0]['middleClassName'];
      mapVal = resp['areaClasses']['largeClasses'][0][1]['middleClasses'][i]
          ['middleClass'][0]['middleClassCode'];
      selectPrefCode['$mapKey'] = mapVal;
      for (int val = 0;
          val <
              resp['areaClasses']['largeClasses'][0][1]['middleClasses'][i]
                      ['middleClass'][1]['smallClasses']
                  .length;
          val++) {
        mapSmallKey = resp['areaClasses']['largeClasses'][0][1]['middleClasses']
                [i]['middleClass'][1]['smallClasses'][val]['smallClass'][0]
            ['smallClassCode'];
        mapSmallVal = resp['areaClasses']['largeClasses'][0][1]['middleClasses']
                [i]['middleClass'][1]['smallClasses'][val]['smallClass'][0]
            ['smallClassName'];
        smallPlace[mapSmallVal] = '$mapSmallKey';
      }
      SearchLocate[mapKey] = smallPlace;
      if (i == 46) print(SearchLocate);
    }
  }

  Future<void> TravelApi() async {
    final url = Uri.parse(
        'https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426?');
    final response = await http.post(url, body: {
      'format': 'json',
      'affiliateId': '20c8801b.9bc4906b.20c8801c.3a69e429',
      'middleClassCode': '${widget.pref}',
      'sort': 'standard',
      'applicationId': '1001393711643575856'
    });
    var res = jsonDecode(response.body);
    print('Response status: ${response.statusCode}');
    return setState(() {
      print(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text('ホテル検索'),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
      ),
      body: ListView.builder(
          itemCount: selectedPrefs[widget.pref].length,
          itemBuilder: (BuildContext context, int index) {
            return Column(children: [
              index != 0
                  ? SizedBox.shrink()
                  : Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'どこへ行きますか?',
                            style: TextStyle(color: Colors.brown),
                          ),
                          selectedPrefKey == null
                              ? SizedBox.shrink()
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedPrefKey = null;
                                    });
                                  },
                                  icon: Icon(Icons.clear))
                        ],
                      )),
              Container(
                width: screenSize.width * 0.9,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedPrefKey = selectedPrefs[widget.pref][index];
                        selectedPrefVal = selectPrefCode[selectedPrefs[widget.pref][index]];
                        keys = SearchLocate['$selectedPrefKey'].keys.toList();
                      });
                    },
                    child: Text(selectedPrefs[widget.pref][index])),
              ),
              selectedPrefKey == selectedPrefs[widget.pref][index]
                  ? Column(
                      children: [
                        for (var key in keys)
                          Container(
                              width: screenSize.width * 1,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextButton(
                                  onPressed: () {
                                    setState((){
                                      selectedName = key;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => hotelDetailPage(
                                                large: 'japan',
                                                middle: selectedPrefVal,
                                                small: SearchLocate['$selectedPrefKey']['$key'],
                                            prefecture:selectedPrefKey,
                                            country:selectedName
                                              )),
                                    );
                                  },
                                  child: Text(key)))
                      ],
                    )
                  : SizedBox.shrink(),
            ]);
          }),
    );
  }
}
