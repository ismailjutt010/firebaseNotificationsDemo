import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotofications(
       RemoteMessage message) async {
    var androidInitilization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitilization = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitilization, iOS: iosInitilization);
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {

        });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      String? title = message.notification?.title.toString();
      String? body = message.notification?.body.toString();
      print(title);
      print(body);
      initLocalNotofications(message);
      showNotification(message);
    });


  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(1000).toString(), 'High importance channel',
        importance: Importance.max);


    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS:darwinNotificationDetails ,
    );

    Future.delayed(
        Duration.zero,
            (){
              _flutterLocalNotificationsPlugin.show(
                  1,
                  message.notification!.title.toString(),
                  message.notification!.body.toString(),
                  notificationDetails);
            }
    );
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        //alert show notification on device
        alert: true,
        //it reads notificaion
        announcement: true,
        //indicators on app showing number on notification
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        //sound of notification
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted Permissions');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted provisional Permissions');
    } else {
      print('User denied Permissions');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}
