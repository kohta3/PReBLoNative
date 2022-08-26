import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/Auth/LoginPage.dart';
import 'package:preblo/SettingScreen.dart';
import 'package:preblo/bottomNavScreen/DirectionScreen.dart';
import 'package:preblo/bottomNavScreen/FavoriteScreen.dart';
import 'package:preblo/bottomNavScreen/MyPage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:preblo/bottomNavScreen/hotelSearchPage.dart';

import 'InMyPage/accountManegment.dart';
import 'bottomNavScreen/TopPage.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  var userState;
  String? accountImage;

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
          accountImage = user.photoURL;
        });
      } else {
        userState = null;
      }
    });
  }

  static const _screens = [
    TopPage(),
    hotelSearchPage(),
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
          child: accountImage == null
              ? Icon(Icons.account_circle)
              : Center(
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                      imageUrl: '${accountImage}',
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover),
                )),
        ),
        title: Image.asset('images/logo.png', alignment: Alignment.topRight),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
              icon: Icon(Icons.settings)),
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
            icon: Icon(Icons.hotel_outlined),
            label: 'ホテル検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_sharp,
              color:Colors.lightBlueAccent,
            ),
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
