import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  // Singleton pattern to ensure only one instance exists
  static final NotificationServices _instance =
      NotificationServices._internal();

  factory NotificationServices() {
    return _instance;
  }

  NotificationServices._internal();

  // Initialize notifications
  Future<void> initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await _flutterLocalNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification click here
      print("Notification Clicked: ${response.payload}");
      // You can navigate to a specific screen or perform an action
    });
  }

  // Handle local notification received on iOS (iOS 10+)
  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // You can add logic here to show a dialog or perform any other action
    print("iOS Local Notification Received: $title");
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    messaging.subscribeToTopic('loads');
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Permission Granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      AppSettings
          .openAppSettings(); // Ask the user to manually enable notifications
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("Device Token: $token");
    return token!;
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      // Foreground notification
      print("Received a foreground message: ${message.messageId}");
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle notification when the app is opened from a terminated or background state
      print("Notification Clicked: ${message.messageId}");
      // Navigate to specific screen based on the notification
    });

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max);

    await _flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationPlugin.show(
      Random().nextInt(1000),
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
      payload: message.data['payload'], // Use this to pass additional data
    );
  }

  Future<void> showLocalNotification(String title, String body) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            Random().nextInt(1000) as String, // Ensure the ID is unique
            'Channel Name',
            channelDescription: 'Channel Description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );
    await _flutterLocalNotificationPlugin.show(
        Random().nextInt(1000), title, body, platformChannelSpecifics,
        payload: 'Trucker');
  }
}

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  await NotificationServices().showNotification(message);
}
