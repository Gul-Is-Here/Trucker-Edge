import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationServices _instance =
      NotificationServices._internal();

  factory NotificationServices() {
    return _instance;
  }

  NotificationServices._internal();

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

    await _flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click here
        String? payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          // Handle navigation or specific action based on payload
          print("Notification Clicked with Payload: $payload");
          // Example: Navigate to a specific screen based on payload
          // Navigator.of(context).pushNamed(payload);
        }
      },
    ).catchError((error) {
      print("Error initializing notifications: $error");
    });

    // iOS foreground notification settings
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
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
      AppSettings.openAppSettings();
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    if (token != null) {
      print("Device Token: $token");
      return token;
    } else {
      print("Failed to retrieve device token.");
      return '';
    }
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print("Received a foreground message: ${message.messageId}");
      showNotification(message);
    }).onError((error) {
      print("Error receiving foreground message: $error");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Notification Clicked: ${message.messageId}");
      // Handle navigation to specific screen here if necessary
    }).onError((error) {
      print("Error handling notification click: $error");
    });

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);

    setupTokenRefreshListener();
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
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

    await _flutterLocalNotificationPlugin
        .show(
      DateTime.now().millisecondsSinceEpoch,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
      payload: message.data['payload'],
    )
        .catchError((error) {
      print("Error showing notification: $error");
    });
  }

  Future<void> showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('custom_channel_id', 'Channel Name',
            channelDescription: 'Channel Description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    await _flutterLocalNotificationPlugin
        .show(Random().nextInt(1000), title, body, platformChannelSpecifics,
            payload: 'Trucker')
        .catchError((error) {
      print("Error showing local notification: $error");
    });
  }

  void setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && newToken.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'token': newToken,
          }, SetOptions(merge: true));
          print("Device token updated successfully.");
        } catch (e) {
          print("Error updating device token: $e");
        }
      }
    }).onError((error) {
      print("Error setting up token refresh listener: $error");
    });
  }
}

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  await NotificationServices().showNotification(message);
}
