import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/DirectionScreen.dart';
import 'package:preblo/FavoriteScreen.dart';
import 'package:preblo/SettingScreen.dart';

import 'TopPage.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  var imageUrl1 = [
    'https://pbs.twimg.com/media/FTA5xHzVsAAkiZx?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRzvnCJagAAoSU7?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRyc4p8acAAcmq8?format=jpg&name=small'
  ];
  var imageUrl2 = [
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large'
  ];

  static const _screens = [
    TopPage(),
    DirectionScreen(),
    FavoriteScreen(),
    SettingScreen()
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: NewGradientAppBar(
        leading: const Icon(Icons.image_rounded),
        title: Image.asset('images/logo.png', alignment: Alignment.topRight),
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
      // extendBodyBehindAppBar: true,

      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purpleAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_sharp),
            label: '投稿',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'お気に入り',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '管理',
          ),
        ],
        // currentIndex: _selectedIndex,
        // onTap: _onItemTapped,
      ),
    );
  }
}
