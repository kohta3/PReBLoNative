import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:postgres/postgres.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StatePage extends StatefulWidget {
  const StatePage({Key? key, required this.uID}) : super(key: key);
  final uID;

  @override
  State<StatePage> createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  double init = 1;
  List Rank = ['引きこもり(Lv1)', 'プチお出かけマン(Lv10)', 'お出かけマン(Lv20)', 'トラベラー(Lv40)', 'ベテラン旅人(Lv70)', '最強のバックパッカー(Lv100)'];
  List prefList = [];
  bool loadPref = false;
  int? userId;
  String? authUserName;

  Future<void> getUserId() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> userInfo = await connection
        .query("SELECT id,name FROM users WHERE uid='${widget.uID}'");
    await connection.close();
    setState(() {
      userId = userInfo[0][0] as int?;
      authUserName = userInfo[0][1];
    });
    await getPref();
  }

  Future<void> getPref() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> wentToPref = await connection
        .query("SELECT pref FROM information WHERE user_id='$userId'");
    List<List<dynamic>> countLike = await connection
        .query("SELECT id FROM likes WHERE user_id='$userId'");
    await connection.close();
    setState(() {
      for (var val in wentToPref) {
        prefList.add(val[0]);
      }
      loadPref = true;
      init = prefList.length*20;
      init+=countLike.length*5;
    });
    print(prefList.toSet().toList());
  }

  wentToThere(sake,onsen, screen, name, url) {
    return Column(
      children: [
        Text(name),
        Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: url,
              width: screen,
            ),
            Column(children: [
              Text('🍶$sake'),
              Text('♨$onsen'),
            ],)
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width * 0.3;
    return Scaffold(
      appBar: NewGradientAppBar(
          title: Text('現在のステータス'),
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
          )),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '現在のランク : ',
                style: TextStyle(color: Colors.grey),
              ),
              (init <= 100)
                  ? Row(children: [
                      Text(Rank[0]),
                      Icon(
                        Icons.celebration,
                        color: Colors.lightBlue,
                      ),
                    ])
                  : (101 <= init && init <= 1000)
                      ? Row(children: [
                          Text(Rank[1]),
                          Icon(Icons.celebration, color: Colors.pinkAccent)
                        ])
                      : (1001 <= init && init <= 2500)
                          ? Row(children: [
                              Text(Rank[2]),
                              Icon(Icons.celebration, color: Colors.pinkAccent)
                            ])
                          : (2501 <= init && init <= 10000)
                              ? Row(children: [
                                  Text(Rank[3]),
                                  Icon(Icons.celebration,
                                      color: Colors.pinkAccent)
                                ])
                              : (10001 <= init && init <= 50000)
                                  ? Row(children: [
                                      Text(Rank[4]),
                                      Icon(Icons.celebration,
                                          color: Colors.pinkAccent)
                                    ])
                                  : (50001 <= init && init <= 100000)
                                      ? Row(children: [
                                          Text(Rank[5]),
                                          Icon(Icons.celebration,
                                              color: Colors.pinkAccent)
                                        ])
                                      : Row(
                                          children: [
                                            Text('君がトップだ'),
                                            Icon(Icons.accessibility_new),
                                          ],
                                        )
            ],
          )),
          init == 100
              ? Container(
                  alignment: Alignment.center,
                  child: Text('あと1ポイントでランクアップ🌞',style: TextStyle(fontSize: 12),),
                )
              : SizedBox.shrink(),
///////////////////////////////////////////ゲージの表示///////////////////////////////////////////
          Container(
              padding: EdgeInsets.all(10),
              child: (init <= 100)
                  ? SfLinearGauge(
                      maximum: 100,
                      maximumLabels: 2,
                      markerPointers: [
                        LinearShapePointer(
                          value: init,
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                      barPointers: [
                        LinearBarPointer(
                            value: init,
                            borderColor: Colors.purpleAccent[100],
                            borderWidth: 10),
                      ],
                    )
                  : (101 <= init && init <= 1000)
                      ? SfLinearGauge(
                          maximum: 1000,
                          minimum: 100,
                          maximumLabels: 2,
                          markerPointers: [
                            LinearShapePointer(
                              value: init,
                              color: Colors.lightBlueAccent,
                            ),
                          ],
                          barPointers: [
                            LinearBarPointer(
                                value: init,
                                borderColor: Colors.purpleAccent[100],
                                borderWidth: 10),
                          ],
                        )
                      : (1001 <= init && init <= 2500)
                          ? SfLinearGauge(
                              maximum: 2500,
                              minimum: 1001,
                              maximumLabels: 2,
                              markerPointers: [
                                LinearShapePointer(
                                  value: init,
                                  color: Colors.lightBlueAccent,
                                ),
                              ],
                              barPointers: [
                                LinearBarPointer(
                                    value: init,
                                    borderColor: Colors.purpleAccent[100],
                                    borderWidth: 10),
                              ],
                            )
                          : (2501 <= init && init <= 10000)
                              ? SfLinearGauge(
                                  maximum: 10000,
                                  minimum: 2501,
                                  maximumLabels: 2,
                                  markerPointers: [
                                    LinearShapePointer(
                                      value: init,
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ],
                                  barPointers: [
                                    LinearBarPointer(
                                        value: init,
                                        borderColor: Colors.purpleAccent[100],
                                        borderWidth: 10),
                                  ],
                                )
                              : (10001 <= init && init <= 50000)
                                  ? SfLinearGauge(
                                      maximum: 50000,
                                      minimum: 10001,
                                      maximumLabels: 2,
                                      markerPointers: [
                                        LinearShapePointer(
                                          value: init,
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ],
                                      barPointers: [
                                        LinearBarPointer(
                                            value: init,
                                            borderColor:
                                                Colors.purpleAccent[100],
                                            borderWidth: 10),
                                      ],
                                    )
                                  : (50001 <= init && init <= 100000)
                                      ? SfLinearGauge(
                                          maximum: 100000,
                                          minimum: 50000,
                                          maximumLabels: 2,
                                          markerPointers: [
                                            LinearShapePointer(
                                              value: init,
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ],
                                          barPointers: [
                                            LinearBarPointer(
                                                value: init,
                                                borderColor:
                                                    Colors.purpleAccent[100],
                                                borderWidth: 10),
                                          ],
                                        )
                                      : SfLinearGauge(
                                          maximum: 1000,
                                          minimum: 500,
                                          maximumLabels: 2,
                                          markerPointers: [
                                            LinearShapePointer(
                                              value: init,
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ],
                                          barPointers: [
                                            LinearBarPointer(
                                                value: init,
                                                borderColor:
                                                    Colors.purpleAccent[100],
                                                borderWidth: 10),
                                          ],
                                        )),
          Text('現在のポイント${init.toInt()}'),
          Container(
              padding: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('あなたが訪れた都道府県 : ', style: TextStyle(color: Colors.grey)),
                  Text(
                    prefList.toSet().toList().length.toString(),
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                  Text(
                    '箇所',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ],
              )),
          loadPref
              ? Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    prefList.contains('北海道')
                        ? wentToThere('国士無双','登別温泉',width, '北海道',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fhokkaido.png?alt=media&token=3f5de6a2-5bf6-4826-b679-18edca445392')
                        : SizedBox.shrink(),
                    prefList.contains('青森県')
                        ? wentToThere('田酒','酸ヶ湯温泉',width, '青森県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Faomori.png?alt=media&token=8c1f4aa2-b94c-4f9a-b9ca-2b7567b059e6')
                        : SizedBox.shrink(),
                    prefList.contains('岩手県')
                        ? wentToThere('あさ開','八幡平温泉郷',width, '岩手県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fiwate.png?alt=media&token=b9b21548-8b1c-4d58-b207-3a1847abfa0b')
                        : SizedBox.shrink(),
                    prefList.contains('宮城県')
                        ? wentToThere('浦霞','鳴子温泉',width, '宮城県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fmiyagi.png?alt=media&token=c45db271-dc90-4332-b78b-8a40ab4a8b80')
                        : SizedBox.shrink(),
                    prefList.contains('秋田')
                        ? wentToThere('新政','鶴の湯温泉',width, '秋田県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fakita.png?alt=media&token=bd463b8d-281c-4da9-9485-cfe95dc31cbe')
                        : SizedBox.shrink(),
                    prefList.contains('山形県')
                        ? wentToThere('十四代','蔵王温泉',width, '山形県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fyamagata.png?alt=media&token=cb71f4b3-0c5c-41f1-a97c-a188fd7c6eb4')
                        : SizedBox.shrink(),
                    prefList.contains('福島県')
                        ? wentToThere('飛露喜','磐梯熱海温泉',width, '福島県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Ffukushima.png?alt=media&token=0f331295-6120-4e13-b95c-efc0404a39ce')
                        : SizedBox.shrink(),
                    prefList.contains('茨城県')
                        ? wentToThere('郷乃誉','五浦温泉',width, '茨城県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fibaraki.png?alt=media&token=2db4e82b-79ad-4b74-afa8-04cd0db59430')
                        : SizedBox.shrink(),
                    prefList.contains('栃木県')
                        ? wentToThere('鳳凰美田','鬼怒川温泉',width, '栃木県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Ftochigi.png?alt=media&token=85068030-3f49-4677-a035-045e90c5e497')
                        : SizedBox.shrink(),
                    prefList.contains('群馬県')
                        ? wentToThere('瀬尾の雪どけ','草津温泉',width, '群馬県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fgumma.png?alt=media&token=7e987ca4-2ba0-4b09-846d-ea4ff7339211')
                        : SizedBox.shrink(),
                    prefList.contains('埼玉県')
                        ? wentToThere('神亀','和銅鉱泉',width, '埼玉県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fsaitama.png?alt=media&token=3060d5b1-8031-4450-8d12-9a5494518377')
                        : SizedBox.shrink(),
                    prefList.contains('千葉県')
                        ? wentToThere('五人娘','白浜温泉',width, '千葉県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fchiba.png?alt=media&token=077bedd1-8850-4720-8eac-0e7d79ba60dd')
                        : SizedBox.shrink(),
                    prefList.contains('東京都')
                        ? wentToThere('沢野井','岩蔵温泉郷',width, '東京都',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Ftokyo.png?alt=media&token=e283f246-4398-4963-b343-20470aa34eff')
                        : SizedBox.shrink(),
                    prefList.contains('神奈川県')
                        ? wentToThere('いずみ橋','箱根湯本温泉',width, '神奈川県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fkanagawa.png?alt=media&token=986050e3-cbbe-453b-bff5-82151ade0770')
                        : SizedBox.shrink(),
                    prefList.contains('新潟県')
                        ? wentToThere('久保田','湯沢温泉',width, '新潟県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fniigata.png?alt=media&token=33e141b4-6266-499a-9082-c6a5aaf45adf')
                        : SizedBox.shrink(),
                    prefList.contains('富山県')
                        ? wentToThere('満寿泉','宇奈月温泉',width, '富山県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Ftoyama.png?alt=media&token=58c00342-3173-49ce-b246-f952e9dcc874')
                        : SizedBox.shrink(),
                    prefList.contains('石川県')
                        ? wentToThere('天狗舞','和倉温泉',width, '石川県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fishikawa.png?alt=media&token=17e1693c-0410-481f-a881-2cd45681c8e7')
                        : SizedBox.shrink(),
                    prefList.contains('福井県')
                        ? wentToThere('黒龍','あわら温泉',width, '福井県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Ffukui.png?alt=media&token=eeab65e7-6f1f-4919-8e3b-c8ce5a4b3269')
                        : SizedBox.shrink(),
                    prefList.contains('山梨県')
                        ? wentToThere('七賢','山中湖温泉',width, '山梨県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fyamanashi.png?alt=media&token=91b48d14-77dd-4c47-a05e-fa7a42fc5659')
                        : SizedBox.shrink(),
                    prefList.contains('長野県')
                        ? wentToThere('真澄','白骨温泉',width, '長野県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fnagano.png?alt=media&token=bc4cf7c4-3f4a-41fe-9030-e2c45148960d')
                        : SizedBox.shrink(),
                    prefList.contains('岐阜県')
                        ? wentToThere('三千盛','下呂温泉',width, '岐阜県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fgifu.png?alt=media&token=715a94b3-0290-4f1a-a442-2c5447d21514')
                        : SizedBox.shrink(),
                    prefList.contains('静岡県')
                        ? wentToThere('磯自慢','熱海温泉',width, '静岡県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fshizuoka.png?alt=media&token=9edc0681-1f3f-4256-b8f1-76b72cf761f8')
                        : SizedBox.shrink(),
                    prefList.contains('愛知県')
                        ? wentToThere('醸し人九平次','蒲郡温泉',width, '愛知県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Faichi.png?alt=media&token=4af64e69-dba5-43da-90b7-531d98e59694')
                        : SizedBox.shrink(),
                    prefList.contains('三重県')
                        ? wentToThere('作','湯の山温泉',width, '三重県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fmie.png?alt=media&token=b436ba0e-156d-40c2-a5ed-8606ed7dc54d')
                        : SizedBox.shrink(),
                    prefList.contains('滋賀県')
                        ? wentToThere('松の司','長浜太閤温泉',width, '滋賀県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fshiga.png?alt=media&token=f4316af2-7c5e-4f52-9a31-0202a26cd49c')
                        : SizedBox.shrink(),
                    prefList.contains('京都府')
                        ? wentToThere('玉乃光','天橋立温泉',width, '京都府',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fkyoto.png?alt=media&token=7f5f3d94-26e3-483e-be32-ceaa12ce9029')
                        : SizedBox.shrink(),
                    prefList.contains('大阪府')
                        ? wentToThere('秋鹿','伏尾温泉',width, '大阪府',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fosaka.png?alt=media&token=689e6376-eb83-4da3-9f9f-e2cc1114c6cc')
                        : SizedBox.shrink(),
                    prefList.contains('兵庫県')
                        ? wentToThere('剣菱','城崎温泉',width, '兵庫県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fhyogo.png?alt=media&token=5d2ee17c-31d6-4773-9492-a30b8a5bf63e')
                        : SizedBox.shrink(),
                    prefList.contains('奈良県')
                        ? wentToThere('風の森','十津川温泉',width, '奈良県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fnara.png?alt=media&token=8a19c317-2ae8-4597-896e-2c2331dcb597')
                        : SizedBox.shrink(),
                    prefList.contains('和歌山県')
                        ? wentToThere('黒牛','白浜温泉',width, '和歌山県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fwakayama.png?alt=media&token=72ea278d-7181-401b-8435-a0563097eb79')
                        : SizedBox.shrink(),
                    prefList.contains('鳥取県')
                        ? wentToThere('鷹勇','皆生温泉',width, '鳥取県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Ftottori.png?alt=media&token=a434ecf7-e4d3-48e0-bfca-c03e2325f4d5')
                        : SizedBox.shrink(),
                    prefList.contains('島根県')
                        ? wentToThere('王祿','玉造温泉',width, '島根県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fshimane.png?alt=media&token=7f796d66-b38c-4fcc-845c-9741a18affc3')
                        : SizedBox.shrink(),
                    prefList.contains('岡山県')
                        ? wentToThere('酒一筋','湯郷温泉',width, '岡山県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fokayama.png?alt=media&token=bb78fe7e-daf8-4f9b-9511-6f25b0c25a4e')
                        : SizedBox.shrink(),
                    prefList.contains('広島県')
                        ? wentToThere('龍勢','宮浜温泉',width, '広島県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fhiroshima.png?alt=media&token=daee3441-c345-4d98-9d95-c2eb37d68de3')
                        : SizedBox.shrink(),
                    prefList.contains('山口県')
                        ? wentToThere('獺祭','長門温泉郷',width, '山口県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fyamaguchi.png?alt=media&token=79841b0f-fe0e-474f-9bb6-669703990927')
                        : SizedBox.shrink(),
                    prefList.contains('徳島県')
                        ? wentToThere('三芳菊','祖谷温泉',width, '徳島県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Ftokushima.png?alt=media&token=484e39e3-9b6f-4303-9c7c-2d5835e00c44')
                        : SizedBox.shrink(),
                    prefList.contains('香川県')
                        ? wentToThere('悦凱陣','琴平温泉郷',width, '香川県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fkagawa.png?alt=media&token=3a207f5e-6597-4ddc-829d-404bae7870a3')
                        : SizedBox.shrink(),
                    prefList.contains('愛媛県')
                        ? wentToThere('梅錦','道後温泉',width, '愛媛県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fehime.png?alt=media&token=582c7a22-89e8-4961-91e2-4157f8d09f46')
                        : SizedBox.shrink(),
                    prefList.contains('高知県')
                        ? wentToThere('南','あしずり温泉郷',width, '高知県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fkochi.png?alt=media&token=4ecf04da-f8ed-457b-a2a1-587fb681dd03')
                        : SizedBox.shrink(),
                    prefList.contains('福岡県')
                        ? wentToThere('庭のうぐいす','筑後川温泉',width, '福岡県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Ffukuoka.png?alt=media&token=6a6d45f9-90f9-407f-8cab-8f81cd611ef2')
                        : SizedBox.shrink(),
                    prefList.contains('佐賀県')
                        ? wentToThere('鍋島','嬉野温泉',width, '佐賀県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fsaga.png?alt=media&token=c6d1ae21-b964-4989-8456-cb6fb6d36b63')
                        : SizedBox.shrink(),
                    prefList.contains('長崎県')
                        ? wentToThere('六十餘洲','小浜温泉',width, '長崎県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fnagasaki.png?alt=media&token=b9481449-3d9e-4d0f-a6af-8c6f2ec9ee77')
                        : SizedBox.shrink(),
                    prefList.contains('大分県')
                        ? wentToThere('西の関','別府温泉',width, '大分県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Foita.png?alt=media&token=c96053e1-f30a-4551-af4f-4a3a8afd1e1b')
                        : SizedBox.shrink(),
                    prefList.contains('熊本県')
                        ? wentToThere('れいざん','黒川温泉',width, '熊本県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fkumamoto.png?alt=media&token=39c58fe5-edb4-4bea-b7ba-0e099bd4826f')
                        : SizedBox.shrink(),
                    prefList.contains('宮崎県')
                        ? wentToThere('千徳','青島温泉',width, '宮崎県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fmiyazaki.png?alt=media&token=78f4f6fb-5971-442f-ad07-9103d6348072')
                        : SizedBox.shrink(),
                    prefList.contains('鹿児島県')
                        ? wentToThere('魔王(焼酎)','霧島温泉郷',width, '鹿児島県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fkagoshima.png?alt=media&token=0b882539-717c-4956-9fbb-50135c59cb6b')
                        : SizedBox.shrink(),
                    prefList.contains('沖縄県')
                        ? wentToThere('残波(泡盛)','川平湾(海)',width, '沖縄県',
                            'https://firebasestorage.googleapis.com/v0/b/my-project-34953-b6df5.appspot.com/o/pref%2Fokinawa.png?alt=media&token=0a5738a3-331b-4b7c-a95d-86eed58a781c')
                        : SizedBox.shrink(),
                  ],
                )
              : SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),
    );
  }
}
