import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:http/http.dart' as http;

import 'Component/AppBar.dart';
import 'DetailPage.dart';

class SerchPlacePage extends StatefulWidget {
  const SerchPlacePage({Key? key,required this.userId}) : super(key: key);
  final userId;
  @override
  State<SerchPlacePage> createState() => _SerchPlacePageState();
}

class _SerchPlacePageState extends State<SerchPlacePage> {
  String country = "";
//////////HTTP接続ここから///////////
  List cites = [''];

  Future<void> _requestAPI(pref) async {
    var compUrl =
        'http://geoapi.heartrails.com/api/json?method=getCities&prefecture=' + pref;
    var url = Uri.parse(compUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse['response']['location']);
      setState(() {
        cites = [];
        for (var city in jsonResponse['response']['location']) cites.add(city['city']);
      });
    } else {
      print("Error");
    }
  }
//////////HTTP接続ここまで///////////

  void slectedPref(String pref) {
    country = pref;
    print(country);
  }
  var _ThisPageRegion = "";
  var _ThisPagePref = "";

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


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenSize.height * 0.07),
          child: appBarComp(tittle: "地域検索")),
      // extendBodyBehindAppBar: true,

      body: ListView(
        children: [
          Column(children: [
            Row(children: const [
              Text("▼地域を選択してください", textAlign: TextAlign.left),
            ]),
            Wrap(
              children: [
                for (int i = 0; i < 9; i++)
                  Container(
                    padding: const EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          slectedPref(selectedRegion[i]);
                          _ThisPageRegion = selectedRegion[i];
                          cites = [""];
                        });
                      },
                      child: Text(selectedRegion[i]),
                    ),
                  ),
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
            Row(children: const [
              Text("▼都道府県を選択してください", textAlign: TextAlign.left),
            ]),
            Container(
              padding: const EdgeInsets.all(3),
              child: (country == '')
                  ? const Text('地域が選択されていません')
                  : Wrap(
                      children: [
                        for (var selectedPref in selectedPrefs[country])
                          Container(
                            padding: const EdgeInsets.all(7),
                            child: ElevatedButton(
                                onPressed: () {
                                  _requestAPI(selectedPref);
                                  _ThisPagePref = selectedPref;
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.lightBlueAccent[100])),
                                child: Text(
                                  selectedPref,
                                  style: const TextStyle(color: Colors.white),
                                )),
                          )
                      ],
                    ),
            ),
            Column(children: [
              Row(
                children: [Text("▼市区町村を選択してください", textAlign: TextAlign.left)],
              ),
              Wrap(
                children: [
                  for (var city in cites)
                    (city == "")
                        ? const Text('都道府県が選択されていません')
                        : Container(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            genre: '',
                                            region: _ThisPageRegion,
                                            pref: _ThisPagePref,
                                            city: city,
                                            userId: widget.userId
                                        )),
                                  );
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.purple[100])),
                                child: Text(
                                  city,
                                  style: const TextStyle(color: Colors.white),
                                )),
                          )
                ],
              ),
            ]),
          ])
        ],
      ),
    );
  }
}
