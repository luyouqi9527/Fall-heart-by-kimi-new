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

  // 返回 bool：true 表示已授权，false 表示未授权
  static Future<bool> checkPermission() async {
    // 这里简化处理，你也可以调用 FlutterForegroundTask.checkNotificationPermission()
    // 但为了统一，我们用 plugin 的平台实现来判断
    final bool? enabled = await _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();
    return enabled ?? false;
  }

  // 请求权限，返回 bool：true 表示授权成功
  static Future<bool> requestPermission() async {
    // Android 13+ 需要动态请求，这里我们用 FlutterForegroundTask 的接口
    final result = await FlutterForegroundTask.requestNotificationPermission();
    // result 可能是枚举，我们转换为 bool
    // 假设 result 是 NotificationPermission 类型，我们检查是否为 granted
    // 但为了简化，我们调用 checkPermission 再次确认
    await FlutterForegroundTask.requestNotificationPermission();
    return await checkPermission();
  }

  static Future<void> showCompletionNotification() async {
    final android = AndroidNotificationDetails(
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

    final details = NotificationDetails(android: android);

    await _plugin.show(
      1001,
      '专注完成！',
      '本次专注已结束，休息一下吧~',
      details,
    );
  }
}
