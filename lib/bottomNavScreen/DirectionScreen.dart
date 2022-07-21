import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/pleaseVerify.dart';
import 'package:uuid/uuid.dart';

import '../NoAuth.dart';
import '../afterPushPage.dart';
import '../main.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({Key? key}) : super(key: key);

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> with RouteAware {
  var userState;
  bool loading = true;
  bool isChecked = false;
  bool doNotKnow = false;
  bool holiday = false;
  bool locateOrPush = false;
  bool ParkingCar = false;
  bool ParkingBike = false;
  bool notVerifyEmail = false;
  String comment = '';
  String ButtonHide = 'わからない';
  String dialogText = '';
  String? uid;
  String? authUserName;
  int? userId;
  double? Lat;
  double? Long;
  List? cites;
  List? citiesApi;
  ////////////////////address/////////////////
  String addressPref = '都道府県';
  String addressCity = '市区町村';
  String addressSmall = '';
  ////////////////////selected/////////////////
  String selectedPref = '';
  String selectedCity = '';
  String selectedSmall = '';
  String selectedLargeGenre = '大区分';
  String selectedSmallGenre = '小区分';
  String selectedComment = '';
  String selectedTitleName = '';
  String selectedNumber = '';
  String selectedUrl = '';
  String selectedAboutDetail = '';
  String image1 = '';
  String image2 = '';
  String image3 = '';
  String image4 = '';
  int selectedReview = 1;
  List<String> selectedS3Path = [];
  DateTime today = DateTime.now();

  final picker = ImagePicker();
  List<XFile?> imageFileList = [];

  SubmitFunc() {
    print(selectedLargeGenre);
    print(categorise[selectedSmallGenre]);
    print(selectedComment);
    print(selectedPref);
    print(selectedCity);
    print(selectedSmall);
    print(_timeStart.format(context));
    print(_timeClose.format(context));
    print(_timeStart2.format(context));
    print(_timeClose2.format(context));
    print(doNotKnow);
    print(isChecked);
    print(ParkingBike);
    print(ParkingCar);
    print(selectedNumber);
    print(holiday);
    print(dayOfTheWeeksBools[dayOfTheWeeks[0]]);
    print(dayOfTheWeeksBools[dayOfTheWeeks[1]]);
    print(dayOfTheWeeksBools[dayOfTheWeeks[2]]);
    print(dayOfTheWeeksBools[dayOfTheWeeks[3]]);
    print(dayOfTheWeeksBools[dayOfTheWeeks[4]]);
    print(dayOfTheWeeksBools[dayOfTheWeeks[5]]);
    print(dayOfTheWeeksBools[dayOfTheWeeks[6]]);
    print(selectedReview);
    print(Lat);
    print(Long);
    print(selectedUrl);
    print(selectedAboutDetail);
    print(selectedTitleName);
    print(image1);
    print(image2);
    print(image3);
    print(image4);
  }

  TimeOfDay _timeStart = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay _timeClose = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay _timeStart2 = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay _timeClose2 = TimeOfDay(hour: 0, minute: 00);

  List prefList = [
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県'
  ];
  Map<String, int> categorise = {
    '自然': 1,
    '建物': 2,
    '買い物': 3,
    '体験': 4,
    '施設': 5,
    'イベント': 6,
    '旅館': 8,
    'ホテル': 9,
    '民宿': 10,
    'ゲストハウス': 11,
    'キャンプ場': 12,
    '車中泊': 13,
    'ライダーハウス': 14,
    'ご当地グルメ': 16,
    '和食': 17,
    '洋食': 18,
    'ファストフード': 19,
    'ファミレス': 20,
    '喫茶店': 21,
    '居酒屋': 22,
    'エスニック': 23,
    'ジョイフル': 24
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
    await getAuth();
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
          uid = user.uid;
          userState = user;
          print(notVerifyEmail);
        });
        getUserId();
      }
    });
  }

  Future<void> getUserId() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> userInfo =
        await connection.query("SELECT id,name FROM users WHERE uid='${uid}'");
    await connection.close();
    setState(() {
      userId = userInfo[0][0] as int?;
      authUserName = userInfo[0][1];
      loading = false;
    });
    print(userId);
  }

  final minio = Minio(
    endPoint: dotenv.env['END_POINT']!,
    region: dotenv.env['REGION']!,
    accessKey: dotenv.env['ACCESS_KEY']!,
    secretKey: dotenv.env['SECRET_KEY']!,
    useSSL: true,
  );

  Future saveToS3() async {
    image1 = '';
    image2 = '';
    image3 = '';
    image4 = '';
    selectedS3Path = [];
    for (int i = 0; i < imageFileList.length; i++)
      try {
        var path = File(imageFileList[i]!.path).toString();
        var dot =
            path.substring(path.length - 5, path.length).replaceAll("'", "");
        String uuid = const Uuid().v4();
        await minio.fPutObject(dotenv.env['BUCKET']!,
            dotenv.env['DIRNAME']! + uuid + dot, imageFileList[i]!.path);
        selectedS3Path.add('https://' +
            dotenv.env['BUCKET']! +
            '.s3.ap-northeast-1.amazonaws.com/' +
            dotenv.env['DIRNAME']! +
            uuid +
            dot);
        addImagePathToDatabase();
      } catch (e) {
        print(e);
      }
  }

  addImagePathToDatabase() {
    switch (selectedS3Path.length) {
      case 1:
        image1 = selectedS3Path[0];
        break;
      case 2:
        image1 = selectedS3Path[0];
        image2 = selectedS3Path[1];
        break;
      case 3:
        image1 = selectedS3Path[0];
        image2 = selectedS3Path[1];
        image3 = selectedS3Path[2];
        break;
      case 4:
        image1 = selectedS3Path[0];
        image2 = selectedS3Path[1];
        image3 = selectedS3Path[2];
        image4 = selectedS3Path[3];
        break;
      case 0:
        print('imageなし');
        break;
    }
  }

  Future<void> _requestAPI(pref) async {
    var compUrl =
        'http://geoapi.heartrails.com/api/json?method=getCities&prefecture=' +
            pref;
    var url = Uri.parse(compUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse['response']['location']);
      setState(() {
        cites = [];
        for (var city in jsonResponse['response']['location'])
          cites?.add(city['city']);
      });
    } else {
      print("Error");
    }
  }

  void _selectTime1() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeStart,
    );
    if (newTime != null) {
      setState(() {
        _timeStart = newTime;
      });
    }
  }

  void _selectTime2() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeClose,
    );
    if (newTime != null) {
      setState(() {
        _timeClose = newTime;
      });
    }
  }

  void _selectTime3() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeStart2,
    );
    if (newTime != null) {
      setState(() {
        _timeStart2 = newTime;
      });
    }
  }

  void _selectTime4() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeClose2,
    );
    if (newTime != null) {
      setState(() {
        _timeClose2 = newTime;
      });
    }
  }

//住所関係の関数
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
        Long = position.latitude;
        Lat = position.longitude;
        cites = [];
        AddressSearchApi();
      });
      print(Long);
    } catch (e) {
      print(e);
    }
  }

  Future<void> AddressSearchApi() async {
    final url = Uri.parse(
        'https://geoapi.heartrails.com/api/json?method=searchByGeoLocation&x=$Long&y=$Lat');
    try {
      final response = await http.get(url);
      var res = jsonDecode(response.body);
      return setState(() {
        addressPref = res['response']['location'][0]['prefecture'];
        addressCity = res['response']['location'][0]['city'];
        addressSmall = res['response']['location'][0]['town'];
        selectedPref = addressPref;
        selectedCity = addressCity;
        selectedSmall = addressSmall;
      });
    } catch (e) {
      dialog("住所の取得に失敗しました。\n手動で入力してください。", '地域を入力してください。');
    }
  }

  dialog(Str1, Str2) {
    showDialog(
        context: context,
        builder: (childContext) {
          return SimpleDialog(
              backgroundColor: Colors.blueAccent,
              title: Text(Str1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(childContext);
                    showSimpleSnackBar(context, Str2);
                  },
                  child: Text("OK"),
                )
              ]);
        });
  }

  void showSimpleSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(children: <Widget>[
        Icon(Icons.check),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(message),
        )
      ]),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Map<String, bool> dayOfTheWeeksBools = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false
  };
  List<String> dayOfTheWeeks = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  List<String> LargeGenres = ['観光地', '宿泊施設', '飲食店'];

  List genresSightSeeing = ["自然", "建物", "買い物", "体験", "施設", "イベント"];
  List genresStay = ["旅館", "ホテル", "民宿", "ゲストハウス", "キャンプ場", "車中泊", "ライダーハウス"];
  List genresEat = [
    'ご当地グルメ',
    '和食',
    '洋食',
    'ファストフード',
    'ファミレス',
    '喫茶店',
    '居酒屋',
    'エスニック',
    'ジョイフル'
  ];

////////表示非表示
  void hideController(bools, hidenText) {
    doNotKnow = bools;
    ButtonHide = hidenText;
  }

  //写真ライブラリの読み込み用
  Future _getImage() async {
    // ignore: deprecated_member_use
    final List<XFile>? pickedFileList =
        await picker.pickMultiImage(imageQuality: 50);
    setState(() {
      if (pickedFileList != null) {
        imageFileList = pickedFileList;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> databasePush() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    await connection.transaction((ctx) async {
      await ctx.query(
          "INSERT INTO information (comment,tittle,pref,city,url,about,image,parkingcar,parkingbicycles,category_id,created_at,monday,tuesday,wednesday,thursday,friday,saturday,sunday,donnotknow,secondhour,vacation,number,lat,long,opne1,opne2,close1,close2,image2,image3,image4,user_id,review,user_name) VALUES ('${selectedComment}','${selectedTitleName}','${selectedPref}','${selectedCity}','${selectedUrl}','${selectedAboutDetail}','${image1}','${ParkingCar}','${ParkingBike}','${categorise[selectedSmallGenre]}',current_timestamp,'${dayOfTheWeeksBools[dayOfTheWeeks[0]]}','${dayOfTheWeeksBools[dayOfTheWeeks[1]]}','${dayOfTheWeeksBools[dayOfTheWeeks[2]]}','${dayOfTheWeeksBools[dayOfTheWeeks[3]]}','${dayOfTheWeeksBools[dayOfTheWeeks[4]]}','${dayOfTheWeeksBools[dayOfTheWeeks[5]]}','${dayOfTheWeeksBools[dayOfTheWeeks[6]]}','${doNotKnow}','${isChecked}','${holiday}','${selectedNumber}','${Long}','${Lat}','${_timeStart.format(context)}','${_timeClose.format(context)}','${_timeStart2.format(context)}','${_timeClose2.format(context)}','${image2}','${image3}','${image4}','${userId}','${selectedReview}','こうた')");
    });
    await connection.close();
  }

  Future<void> searchAddress() async {
    final url = Uri.parse(
        'https://msearch.gsi.go.jp/address-search/AddressSearch?q=$selectedPref+$selectedCity+$selectedSmall');
    final response = await http.get(url);
    var res = jsonDecode(response.body);
    return setState(() {
      Lat = res[0]['geometry']['coordinates'][0];
      Long = res[0]['geometry']['coordinates'][1];
    });
  }

  inputCheck() async {
    if (selectedComment.isEmpty ||
        selectedTitleName.isEmpty ||
        selectedLargeGenre == '大区分' ||
        selectedSmallGenre == '小区分' ||
        addressCity == '市区町村') {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("入力エラー"),
            content: Text("未入力の項目があります。"),
            actions: <Widget>[
              // ボタン領域
              ElevatedButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    } else if (imageFileList.length > 4) {
      await dialog('画像は最大4枚まで選択できます。', '画像を4枚以下に設定して下さい');
    } else if (Lat == null || Long == null) {
      await searchAddress();
      await saveToS3();
      await databasePush();
      await afterNavigator();
    } else {
      await saveToS3();
      await databasePush();
      await afterNavigator();
    }
    print('$Lat+unko+$Long');
  }

  Future<void> afterNavigator() async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return afterAddedPage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final double begin = 0.0;
          final double end = 1.0;
          final Animatable<double> tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final Animation<double> doubleAnimation = animation.drive(tween);
          return FadeTransition(
            opacity: doubleAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

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
                    ? ListView(children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text('👇今の気持ちを教えてください。※必須'),
                                  ),
                                  SizedBox(
                                      width: screenSize.width * 1,
                                      child: TextFormField(
                                        maxLength: 20,
                                        obscureText: false,
                                        maxLines: 1,
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: InputDecoration(
                                          hintText: 'ひとことどうぞ。',
                                          icon: Icon(Icons.comment,
                                              color: Colors.brown),
                                        ),
                                        onChanged: (getTextComment) {
                                          selectedComment = getTextComment;
                                        },
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text('👇ジャンルを選択してください。※必須'),
                                  ),
                                  Row(children: [
                                    DropdownButton(
                                      hint: Text(selectedLargeGenre),
                                      items: [
                                        for (var LargeGenre in LargeGenres)
                                          DropdownMenuItem(
                                            value: LargeGenre,
                                            child: Text(LargeGenre),
                                            onTap: () {
                                              setState(() {
                                                selectedLargeGenre = LargeGenre;
                                                selectedSmallGenre = '小区分';
                                              });
                                            },
                                          ),
                                      ],
                                      onChanged: (String) {},
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    selectedLargeGenre == '観光地'
                                        ? DropdownButton(
                                            hint: Text(selectedSmallGenre),
                                            items: [
                                              for (var SmallGenre
                                                  in genresSightSeeing)
                                                DropdownMenuItem(
                                                  value: SmallGenre,
                                                  child: Text(SmallGenre),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedSmallGenre =
                                                          SmallGenre;
                                                    });
                                                  },
                                                ),
                                            ],
                                            onChanged: (String) {},
                                          )
                                        : selectedLargeGenre == '宿泊施設'
                                            ? DropdownButton(
                                                hint: Text(selectedSmallGenre),
                                                items: [
                                                  for (var SmallGenre
                                                      in genresStay)
                                                    DropdownMenuItem(
                                                      value: SmallGenre,
                                                      child: Text(SmallGenre),
                                                      onTap: () {
                                                        setState(() {
                                                          selectedSmallGenre =
                                                              SmallGenre;
                                                        });
                                                      },
                                                    ),
                                                ],
                                                onChanged: (String) {},
                                              )
                                            : selectedLargeGenre == '飲食店'
                                                ? DropdownButton(
                                                    hint: Text(
                                                        selectedSmallGenre),
                                                    items: [
                                                      for (var SmallGenre
                                                          in genresEat)
                                                        DropdownMenuItem(
                                                          value: SmallGenre,
                                                          child:
                                                              Text(SmallGenre),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedSmallGenre =
                                                                  SmallGenre;
                                                            });
                                                          },
                                                        ),
                                                    ],
                                                    onChanged: (String) {},
                                                  )
                                                : Text(
                                                    'ジャンルを選択してください',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                  ]),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text('👇どのくらいおススメですか?'),
                                  ),
                                  Row(
                                    children: [
                                      Text('おススメ度'),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      DropdownButton(
                                        hint: Text(selectedReview.toString()),
                                        items: [
                                          for (int i = 1; i < 6; i++)
                                            DropdownMenuItem(
                                              value: i,
                                              child: Text(i.toString()),
                                              onTap: () {
                                                setState(() {
                                                  selectedReview = i;
                                                });
                                              },
                                            ),
                                        ],
                                        onChanged: (String) {},
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text('👇なんていう場所ですか?※必須'),
                                  ),
                                  Row(children: [
                                    Icon(Icons.travel_explore,
                                        color: Colors.brown),
                                    SizedBox(
                                        width: screenSize.width * 0.5,
                                        child: TextField(
                                          maxLength: 20,
                                          obscureText: false,
                                          maxLines: 1,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                            labelText: '場所の名前',
                                          ),
                                          onChanged: (getName) {
                                            selectedTitleName = getName;
                                          },
                                        )),
                                    SizedBox(
                                      width: screenSize.width * 0.1,
                                    ),
                                  ]),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(children: [
                                        Text('👇登録する地域を教えてください。'),
                                        OutlinedButton(
                                          onPressed: () {
                                            getLocation();
                                          },
                                          child: Text(
                                            '現在地を選択',
                                            style: TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            surfaceTintColor: Colors.brown,
                                            primary: Colors.brown,
                                            side: BorderSide(
                                              color: Colors.brown, //枠線の色
                                            ), // 色
                                          ),
                                        )
                                      ])),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: DropdownButton(
                                            hint: Text(addressPref),
                                            items: [
                                              for (var prefs in prefList)
                                                DropdownMenuItem(
                                                  value: '$prefs',
                                                  child: Text(prefs),
                                                  onTap: () {
                                                    setState(() {
                                                      addressPref = prefs;
                                                    });
                                                  },
                                                ),
                                            ],
                                            onChanged: (String? value) {
                                              setState(() {
                                                cites = [];
                                                addressCity = '市区町村';
                                                Lat = null;
                                                Long = null;
                                                addressSmall = '';
                                                selectedPref = addressPref;
                                                _requestAPI(selectedPref);
                                              });
                                            }),
                                      ),
                                      Center(
                                        child: cites == null
                                            ? (addressCity == '市区町村')
                                                ? Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    height: 30,
                                                    width:
                                                        screenSize.width * 0.6,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .grey))),
                                                    child: Text(
                                                      '都道府県を選択してください',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 50,
                                                    child: Text(addressCity))
                                            : DropdownButton(
                                                hint: Text(addressCity),
                                                items: [
                                                  for (var city in cites!)
                                                    DropdownMenuItem(
                                                      value: '$city',
                                                      child: Text(city),
                                                      onTap: () {
                                                        setState(() {
                                                          addressCity = city;
                                                        });
                                                      },
                                                    ),
                                                ],
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    Lat = null;
                                                    Long = null;
                                                    addressSmall = '';
                                                    selectedCity = addressCity;
                                                  });
                                                }),
                                      ),
                                      addressSmall.isEmpty
                                          ? Center(
                                              child: SizedBox(
                                              width: screenSize.width * 0.5,
                                              child: TextField(
                                                maxLength: 20,
                                                obscureText: false,
                                                maxLines: 1,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  labelText: '以下の住所',
                                                ),
                                                onChanged: (getTextAdress) {
                                                  Lat = null;
                                                  Long = null;
                                                  selectedSmall = getTextAdress;
                                                },
                                              ),
                                            ))
                                          : Container(
                                              alignment: Alignment.bottomCenter,
                                              height: 30,
                                              width: screenSize.width * 0.6,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.grey))),
                                              child: Text(
                                                addressSmall,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[600]),
                                              ),
                                            )
                                    ],
                                  ),
///////////////////////////////////////////////////営業時間////////////////////////////////
                                  Row(children: [
                                    const SizedBox(
                                      child: Text('👇営業時間を教えてください。'),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          doNotKnow != false
                                              ? hideController(
                                                  false, 'わからない') //入力できるとき
                                              : hideController(
                                                  true, '入力する'); //わからないとき
                                          isChecked = false;
                                        });
                                      },
                                      child: Text(
                                        ButtonHide,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        surfaceTintColor: Colors.brown,
                                        primary: Colors.brown,
                                        side: BorderSide(
                                          color: Colors.brown, //枠線の色
                                        ), // 色
                                      ),
                                    )
                                  ]),
                                  Column(children: [
                                    (doNotKnow == false)
                                        ? Row(
                                            children: [
                                              SizedBox(
                                                width: screenSize.width * 0.25,
                                                child: ElevatedButton(
                                                  onPressed: _selectTime1,
                                                  child: Text(_timeStart
                                                      .format(context)),
                                                ),
                                              ),
                                              Text('から'),
                                              SizedBox(
                                                width: screenSize.width * 0.25,
                                                child: ElevatedButton(
                                                  onPressed: _selectTime2,
                                                  child: Text(_timeClose
                                                      .format(context)),
                                                ),
                                              ),
                                              Checkbox(
                                                  activeColor: Colors
                                                      .lightBlueAccent[100],
                                                  value: isChecked,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isChecked = value!;
                                                    });
                                                  }),
                                              Text("行を追加"),
                                            ],
                                          )
                                        : Text(''),
/////////////////////////////////////////////行を追加した場合/////////////////////////////////////////////
                                    (isChecked == true)
                                        ? Row(children: [
                                            SizedBox(
                                              width: screenSize.width * 0.25,
                                              child: ElevatedButton(
                                                  onPressed: _selectTime3,
                                                  child: Text(
                                                    _timeStart2.format(context),
                                                  )),
                                            ),
                                            const Text('から'),
                                            SizedBox(
                                              width: screenSize.width * 0.25,
                                              child: ElevatedButton(
                                                onPressed: _selectTime4,
                                                child: Text(_timeClose2
                                                    .format(context)),
                                              ),
                                            ),
                                          ])
/////////////////////////////////////////////休業日/////////////////////////////////////////////
                                        : Text(''),
                                  ]),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text('👇休みはありますか？'),
                                  ),
                                  Row(children: [
                                    Checkbox(
                                        value: holiday,
                                        onChanged: (value) {
                                          setState(() {
                                            holiday = value!;
                                          });
                                        }),
                                    const Text(
                                      '休みがある場合はチェックて下さい',
                                      style: TextStyle(color: Colors.brown),
                                    )
                                  ]),
                                  (holiday == false)
                                      ? Text('')
                                      : Wrap(
                                          children: [
                                            for (int i = 0; i < 7; i++)
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                width: screenSize.width * 0.2,
                                                child: Column(children: [
                                                  Text(dayOfTheWeeks[i]),
                                                  Checkbox(
                                                      value: dayOfTheWeeksBools[
                                                          dayOfTheWeeks[i]],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dayOfTheWeeksBools[
                                                              dayOfTheWeeks[
                                                                  i]] = value!;
                                                        });
                                                      }),
                                                ]),
                                              )
                                          ],
                                        ),
/////////////////////////////////////////////駐車場-駐輪場/////////////////////////////////////////////
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text('👇駐車場と駐輪場はありますか？'),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.airport_shuttle,
                                            color: Colors.brown,
                                          ),
                                          Text(
                                            '駐車場',
                                            style:
                                                TextStyle(color: Colors.brown),
                                          ),
                                          Checkbox(
                                              activeColor:
                                                  Colors.lightBlueAccent[100],
                                              value: ParkingCar,
                                              onChanged: (value) {
                                                setState(() {
                                                  ParkingCar = value!;
                                                });
                                              }),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Icon(Icons.moped,
                                              color: Colors.brown),
                                          Text('駐輪場',
                                              style: TextStyle(
                                                  color: Colors.brown)),
                                          Checkbox(
                                              activeColor:
                                                  Colors.lightBlueAccent[100],
                                              value: ParkingBike,
                                              onChanged: (value) {
                                                setState(() {
                                                  ParkingBike = value!;
                                                });
                                              }),
                                        ],
                                      ),
/////////////////////////////////////////////備考/////////////////////////////////////////////
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text('👇詳細&備考について。'),
                                      ),
                                      SizedBox(
                                          width: screenSize.width * 1,
                                          height: screenSize.height * 0.2,
                                          child: TextField(
                                            onChanged: (val) {
                                              selectedAboutDetail = val;
                                            },
                                            obscureText: false,
                                            maxLines: 5,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white30,
                                              filled: true,
                                              hintText: '詳細や説明があれば教えてください。',
                                              icon: Icon(
                                                  Icons.description_outlined,
                                                  color: Colors.brown),
                                            ),
                                          )),
/////////////////////////////////////////////URL/////////////////////////////////////////////
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text('👇URLを入力してください。'),
                                      ),
                                      SizedBox(
                                          width: screenSize.width * 1,
                                          child: TextField(
                                            onChanged: (val) {
                                              selectedUrl = val;
                                            },
                                            obscureText: false,
                                            maxLines: 1,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            decoration: InputDecoration(
                                              hintText: 'リンク先を入力',
                                              icon: Icon(Icons.link,
                                                  color: Colors.brown),
                                            ),
                                          )),
/////////////////////////////////////////////電話番号/////////////////////////////////////////////
                                      Container(
                                        padding: EdgeInsets.only(top: 20),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text('👇電話番号を入力してください'),
                                      ),
                                      SizedBox(
                                          width: screenSize.width * 1,
                                          child: TextField(
                                            obscureText: false,
                                            maxLines: 1,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            decoration: InputDecoration(
                                              hintText: '電話番号を入力',
                                              icon: Icon(Icons.call,
                                                  color: Colors.brown),
                                            ),
                                            onChanged: (getNumber) {
                                              selectedNumber = getNumber;
                                            },
                                          )),
/////////////////////////////////////////////画像/////////////////////////////////////////////
                                      Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(top: 20),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text('👇画像を選択してください。※最大4枚'),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: _getImage,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.brown,
                                                  ),
                                                  child: Row(children: const [
                                                    Icon(Icons.image),
                                                    Text("写真を選ぶ")
                                                  ])),
                                              GestureDetector(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.clear,
                                                      color: Colors.brown,
                                                    ),
                                                    Text(
                                                      '選択をクリア',
                                                      style: TextStyle(
                                                          color: Colors.brown),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    imageFileList = [];
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                          imageFileList.length == 0
                                              ? const Text('画像が選択されていません')
                                              : Wrap(
                                                  children: [
                                                    for (var image
                                                        in imageFileList)
                                                      SizedBox(
                                                        width:
                                                            screenSize.width *
                                                                0.4,
                                                        child: Image.file(
                                                          File(image!.path),
                                                          width:
                                                              screenSize.width *
                                                                  0.4,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                  ],
                                                ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                  Text('経度' +
                                      Lat.toString() +
                                      '緯度' +
                                      Long.toString()),
                                  ElevatedButton(
                                    onPressed: () async {
                                      SubmitFunc();
                                      print(today);
                                      await inputCheck();
                                      await SubmitFunc();
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('投稿'),
                                          Icon(Icons.whatshot)
                                        ]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ])
                    : Center(child: pleaseVerify()));
  }
}
