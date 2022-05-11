import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaminarayancounter/constant.dart';
import 'my_home_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

late final SharedPreferences prefs;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  MobileAds.instance.initialize();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: headerTitle,
    androidNotificationOngoing: true,
  );

 // await _configureLocalTimeZone();

  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');
  //
  // /// Note: permissions aren't requested here just to demonstrate that can be
  // /// done later
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //         requestAlertPermission: false,
  //         requestBadgePermission: false,
  //         requestSoundPermission: false,
  //         onDidReceiveLocalNotification: (
  //           int id,
  //           String? title,
  //           String? body,
  //           String? payload,
  //         ) async {
  //           didReceiveLocalNotificationSubject.add(
  //             ReceivedNotification(
  //               id: id,
  //               title: title,
  //               body: body,
  //               payload: payload,
  //             ),
  //           );
  //         });
  //
  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: initializationSettingsIOS,
  // );
  //
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String? payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  //   selectedNotificationPayload = payload;
  //   selectNotificationSubject.add(payload);
  // });

  runApp(const MyApp());
}

// Future<void> _configureLocalTimeZone() async {
//   if (kIsWeb || Platform.isLinux) {
//     return;
//   }
//   tz.initializeTimeZones();
//   final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZoneName!));
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
   // _requestPermissions();
   // scheduleNotification();
  }

  // void _requestPermissions() {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           MacOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  // }

  @override
  void dispose() {
   // didReceiveLocalNotificationSubject.close();
   // selectNotificationSubject.close();
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

  // scheduleNotification() async {
  //   await _scheduleDailyTenAMNotification();
  //   await _scheduleWeeklyMondayTenAMNotification();
  // }
  //
  // Future<void> _scheduleDailyTenAMNotification() async {
  //   final Int64List vibrationPattern = Int64List(4);
  //   vibrationPattern[0] = 0;
  //   vibrationPattern[1] = 1000;
  //   vibrationPattern[2] = 5000;
  //   vibrationPattern[3] = 2000;
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'daily scheduled notification title',
  //       'daily scheduled notification body',
  //       _nextInstanceOfTenAM(),
  //       NotificationDetails(
  //         android: AndroidNotificationDetails('daily notification channel id',
  //             'daily notification channel name',
  //             channelDescription: 'daily notification description',
  //             icon: 'secondary_icon',
  //             largeIcon:
  //                 const DrawableResourceAndroidBitmap('sample_large_icon'),
  //             vibrationPattern: vibrationPattern,
  //             enableLights: true,
  //             color: const Color.fromARGB(255, 255, 0, 0),
  //             ledColor: const Color.fromARGB(255, 255, 0, 0),
  //             ledOnMs: 1000,
  //             ledOffMs: 500),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }
  //
  // Future<void> _scheduleWeeklyMondayTenAMNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'weekly scheduled notification title',
  //       'weekly scheduled notification body',
  //       _nextInstanceOfMondayTenAM(),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails('weekly notification channel id',
  //             'weekly notification channel name',
  //             channelDescription: 'weekly notificationdescription'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  // }
  //
  // tz.TZDateTime _nextInstanceOfTenAM() {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduledDate =
  //       tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }
  //
  // tz.TZDateTime _nextInstanceOfMondayTenAM() {
  //   tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
  //   while (scheduledDate.weekday != DateTime.monday) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }
}
