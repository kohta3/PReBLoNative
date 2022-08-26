import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'StartPage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with RouteAware {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PReBLo',
      navigatorObservers: <NavigatorObserver>[routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Murecho',
      ),
      home: const StartPage(),
    );
  }
}
