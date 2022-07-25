import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:postgres/postgres.dart';
import 'package:preblo/main.dart';
import 'package:preblo/submissionDetailsPage.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.genre,
    required this.region,
    required this.pref,
    required this.city,
    required this.userId,
  }) : super(key: key);
  final genre;
  final region;
  final pref;
  final city;
  final userId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with RouteAware {
  var newInputCorrect;
  bool loading = true;
  String? Genre;
  String? Pref;
  String? City;

  _firstFunction(word) {
    return Text(
      word,
      style: TextStyle(
        fontSize: 16,
      ),
    );
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
    Genre = widget.genre;
    Pref = widget.pref;
    City = widget.city;
    var connection = PostgreSQLConnection(
        "ec2-35-174-56-18.compute-1.amazonaws.com", 5432, "d7b3j5jpksdl1f",
        username: "nidpustzmfzulk",
        password:
            "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63",
        useSSL: true);
    await connection.open();
    if (widget.genre != '') {
      print('ジャンルを選択');
      List<List<dynamic>> categoryResults = await connection
          .query("SELECT id FROM categories WHERE category='$Genre'");
      List<List<dynamic>> correctResults = await connection.query(
          "SELECT * FROM information WHERE category_id='${categoryResults[0][0]}'");
      await connection.close();
      return setState(() {
        newInputCorrect = correctResults;
        loading = false;
      });
    } else {
      print('地域を選択');
      List<List<dynamic>> regionResults = await connection
          .query("SELECT * FROM information WHERE city='$City'");
      await connection.close();
      return setState(() {
        newInputCorrect = regionResults;
        loading = false;
      });
    }
  }

  CacheManager get _defaultCacheManager => CacheManager(
    Config(
      'CachedImageKey',
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 150,
    ),
  );


  void didPush() async {
    databasePullData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: NewGradientAppBar(
          title: (widget.genre == "")
              ? _firstFunction(
                  '検索結果 ( 地域:' + widget.pref + '>' + widget.city + " ) ")
              : _firstFunction('検索結果 ( カテゴリー:' + widget.genre + " ) "),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_box_rounded),
            ),
          ],
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
          ),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //カラム数
                ),
                itemCount: newInputCorrect.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => submissionDetailsPage(
                                infoId: newInputCorrect[index][0], userId: widget.userId,)),
                      );
                    },
                    child: CachedNetworkImage(
                      cacheManager: _defaultCacheManager,
                      imageUrl: newInputCorrect[index][10],
                      width: screenSize.width * 0.33,
                      height: 120,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
              ));
  }
}
