import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/tabPage/firstTabScreen.dart';
import 'package:preblo/tabPage/secondTabScreen.dart';

import 'main.dart';

class submissionDetailsPage extends StatefulWidget {
  const submissionDetailsPage(
      {Key? key, required this.infoId, required this.userId})
      : super(key: key);
  final infoId;
  final userId;

  @override
  State<submissionDetailsPage> createState() => _submissionDetailsPageState();
}

class _submissionDetailsPageState extends State<submissionDetailsPage>
    with TickerProviderStateMixin, RouteAware {
  late TabController _tabController;
  List infoList = [];
  List users = [];
  int likes = 0;
  var selectedInfoId;
  bool loading = true;
  //information
  String? telephoneNumber;
  String? url;
  String? infoDetail;
  String? imageUrl1;
  String? imageUrl2;
  String? imageUrl3;
  String? imageUrl4;
  String? pref;
  String? city;
  String? userName;
  String? account_url;
  int recommend = 5;
  int userId = 1;
  int? countLike;
  DateTime? open1;
  DateTime close1 = DateTime(0, 0, 0, 12, 30);
  DateTime open2 = DateTime(0, 0, 0, 13, 0);
  DateTime close2 = DateTime(0, 0, 0, 18, 50);
  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool carPort = false;
  bool bicycleParking = false;
  bool doNotKnow = false;
  bool secondHour = false;
  List authUserLikes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> databasePullData() async {
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    List<List<dynamic>> infoResults = await connection
        .query("SELECT * FROM information WHERE id='${widget.infoId}'");
    List<List<dynamic>> User = await connection.query("SELECT * FROM users");
    List<List<dynamic>> Likes = await connection.query(
        "select information_id, count(information_id) from likes where information_id = '${widget.infoId}' group by information_id;");
    List<List<dynamic>> userLikes = await connection
        .query("SELECT information_id FROM likes WHERE user_id='${userId}'");

    await connection.close();
    return setState(() {
      infoList = infoResults;
      loading = false;
      users = User;
      try{
        countLike = Likes[0][1];
      }catch(e){
        countLike = 0;
      }
      print('ここまで');
      for (var user in users)
        infoList[0][37] == user[0] ? userName = user[1] : SizedBox.shrink();
      for (var user in users)
        infoList[0][37] == user[0] ? account_url = user[9] : SizedBox.shrink();
      for (var userLike in userLikes) authUserLikes.add(userLike[0]);
      print('authUserLikes');
    });
  }

  void didPush() async {
    await databasePullData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text('検索結果'),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
        bottom: TabBar(
          indicatorWeight: 5,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          controller: _tabController,
          tabs: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Tab(icon: Icon(Icons.account_balance)),
              Text('基本&フォト')
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Tab(icon: Icon(Icons.map)), Text('地図&周辺')]),
          ],
        ),
      ),
      // extendBodyBehindAppBar: true,

      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                firstTabScreen(
                  PlaceName: infoList[0][2],
                  telephoneNumber: infoList[0][27],
                  url: infoList[0][5],
                  infoDetail: infoList[0][7],
                  images: [
                    infoList[0][10],
                    infoList[0][34],
                    infoList[0][35],
                    infoList[0][36]
                  ],
                  recommend: infoList[0][38],
                  infoId: infoList[0][0],
                  open1: infoList[0][30],
                  close1: infoList[0][32],
                  open2: infoList[0][31],
                  close2: infoList[0][33],
                  sunday: false,
                  monday: false,
                  tuesday: false,
                  wednesday: false,
                  thursday: false,
                  friday: false,
                  saturday: false,
                  carPort: infoList[0][11],
                  bicycleParking: infoList[0][12],
                  pref: infoList[0][3],
                  city: infoList[0][4],
                  doNotKnow: infoList[0][24],
                  secondHour: infoList[0][25],
                  vacation: infoList[0][26],
                  UserName: userName,
                  CountLike: countLike,
                  AuthUserLikes: authUserLikes,
                  AuthUserId: widget.userId,
                  accountImage: account_url,
                ),
                secondTabScreen(
                    Latitude: infoList[0][28],
                    Lightness: infoList[0][29],
                    PlaceName: infoList[0][2],
                    image: infoList[0][10])
              ],
            ),
    );
  }
}
