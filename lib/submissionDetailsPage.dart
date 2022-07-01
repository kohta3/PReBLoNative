import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/tabPage/firstTabScreen.dart';
import 'package:preblo/tabPage/secondTabScreen.dart';
import 'package:http/http.dart' as http;

class submissionDetailsPage extends StatefulWidget {
  const submissionDetailsPage({Key? key}) : super(key: key);

  @override
  State<submissionDetailsPage> createState() => _submissionDetailsPageState();
}

class _submissionDetailsPageState extends State<submissionDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var latitude = 32.847806;
  var lightness = 130.725823;
  String placeName = 'むささび';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text('$placeName'),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),

        bottom:  TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          controller: _tabController,
          tabs:  <Widget>[
            Tab(icon: Icon(Icons.account_balance)),
            Tab(icon: Icon(Icons.map)),
          ],
        ),
      ),
      // extendBodyBehindAppBar: true,

      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          firstTabScreen(PlaceName: placeName),
          secondTabScreen(Latitude: latitude,Lightness: lightness, PlaceName: placeName),
        ],
      ),
    );
  }
}
