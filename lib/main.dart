import 'package:flutter/material.dart';
import 'StartPage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
