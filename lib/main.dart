import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaminarayancounter/constant.dart';

import 'my_home_page.dart';

late final SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: headerTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.black),
            actionsIconTheme: IconThemeData(color: Colors.black)),
        cardColor: Colors.deepOrange,
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: headerTitle),
    );
  }
}
