import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/tabPage/firstTabScreen.dart';
import 'package:preblo/tabPage/secondTabScreen.dart';

class submissionDetailsPage extends StatefulWidget {
  const submissionDetailsPage({Key? key}) : super(key: key);

  @override
  State<submissionDetailsPage> createState() => _submissionDetailsPageState();
}

class _submissionDetailsPageState extends State<submissionDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var latitude = 32.847806;
  var lightness =130.725823;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: const Text('場所の名前'),
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
          firstTabScreen(),
          secondTabScreen(Latitude: latitude,Lightness: lightness),
        ],
      ),
    );
  }
}
