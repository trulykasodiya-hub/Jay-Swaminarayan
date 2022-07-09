import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

/// push notification click and receive requestNotificationPermissions... class..start
class AppNotifications {
  static String fcmToken = '';
  static Future<void> init() async {

    FirebaseMessaging.instance.requestPermission(
        sound: true, badge: true, alert: true, provisional: true);

    fcmToken = (await FirebaseMessaging.instance.getToken())!;

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
    });
  }
}
