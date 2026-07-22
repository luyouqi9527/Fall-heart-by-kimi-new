import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);
    await _plugin.initialize(initSettings);
  }

  static Future<NotificationPermission> checkPermission() =>
      FlutterForegroundTask.checkNotificationPermission();

  static Future<NotificationPermission> requestPermission() =>
      FlutterForegroundTask.requestNotificationPermission();

  static Future<void> showCompletionNotification() async {
    const android = AndroidNotificationDetails(
      'fall_heart_completion',
      '专注完成',
      channelDescription: 'Fall Heart 专注结束提醒',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 400, 200, 400]),
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: android);

    await _plugin.show(
      1001,
      '专注完成！',
      '本次专注已结束，休息一下吧~',
      details,
    );
  }
}
