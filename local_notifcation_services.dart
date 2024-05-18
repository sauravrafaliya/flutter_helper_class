
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  static Future initialNotification()async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // set image => android/app/src/main/res/drawable/ic_launcher.png
    const AndroidInitializationSettings initializationSettingsAndroid =  AndroidInitializationSettings('ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =  DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,);


    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({String title = "",String body = "",int notificationId = 0})async{

    AndroidNotificationDetails notificationAndroidSpecifics = AndroidNotificationDetails(
        "${DateTime.now().microsecondsSinceEpoch}","${DateTime.now().millisecondsSinceEpoch}",
        channelDescription: DateTime.now().toString(),
        importance: Importance.max,
        priority: Priority.high,
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );

    NotificationDetails notificationPlatformSpecifics =
    NotificationDetails(android: notificationAndroidSpecifics,iOS:darwinNotificationDetails);

    Random random = Random(5);
    int num = random.nextInt(100000);
    print(notificationId);
    await flutterLocalNotificationsPlugin.show(
        (notificationId != 0 ? notificationId : num),
        title,
        body,
        notificationPlatformSpecifics
    );
  }



}