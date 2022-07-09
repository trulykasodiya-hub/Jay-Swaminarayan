import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaminarayancounter/constant.dart';
import 'my_home_page.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();
  MobileAds.instance.initialize();
  await FacebookAudienceNetwork.init(
      iOSAdvertiserTrackingEnabled: true //default false
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: headerTitle,
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    firebaseCloudMessagingListeners();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: headerTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pl', 'PL'),
      ],
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

  Timer? timer;

  /// fcm token generate
  void firebaseCloudMessagingListeners() {
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
       Timer.periodic(const Duration(seconds: 4), (Timer t) async {
         var url = "https://satyamsteelindustries.com/api/token.php";
         var formData = FormData.fromMap({
           'token': '$token',
         });
         var response = await Dio().post(url, data: formData);
         if(response.data['status'] == 201) {
           t.cancel();
         }
        });
      });
    });
  }

  /// fcm token store in database..
  addData(token) async {
    if (!kIsWeb && Platform.isAndroid) {
      var url = "https://satyamsteelindustries.com/api/token.php";
      var formData = FormData.fromMap({
        'token': '$token',
      });
      var response = await Dio().post(url, data: formData);
      print("response => ${response.data}");
     if(response.data['status'] == 201) {
       timer!.cancel();
     }
    }
  }
}
