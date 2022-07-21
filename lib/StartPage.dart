import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/Auth/LoginPage.dart';
import 'package:preblo/SettingScreen.dart';
import 'package:preblo/bottomNavScreen/DirectionScreen.dart';
import 'package:preblo/bottomNavScreen/FavoriteScreen.dart';
import 'package:preblo/bottomNavScreen/MyPage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'InMyPage/accountManegment.dart';
import 'bottomNavScreen/TopPage.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  var userState;

  @override
  void initState() {
    super.initState();
    initialization();
    getAuth();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  getAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userState = user;
        });
      } else {
        userState = null;
      }
    });
  }


  static const _screens = [
    TopPage(),
    DirectionScreen(),
    FavoriteScreen(),
    MyPage()
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        leading: GestureDetector(
            onTap: () {
              userState == null
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => loginPage()),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountManagePage()));
            },
            child: Icon(Icons.account_circle)),
        title: Image.asset('images/logo.png', alignment: Alignment.topRight),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            },
            icon: const Icon(Icons.settings),
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
            icon: Icon(Icons.people_alt),
            label: 'マイページ',
          ),
        ],
        // currentIndex: _selectedIndex,
        // onTap: _onItemTapped,
      ),
    );
  }
}
