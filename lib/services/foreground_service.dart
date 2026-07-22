import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(FallHeartTaskHandler());
}

class FallHeartTaskHandler extends TaskHandler {
  int _remainingSeconds = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('FallHeart foreground service started');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // 不需要周期性事件，倒计时由 UI 主动更新通知
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    debugPrint('FallHeart foreground service destroyed');
  }

  @override
  void onReceiveData(Object data) {
    if (data is int) {
      _remainingSeconds = data;
      _updateNotification();
    }
  }

  void _updateNotification() {
    FlutterForegroundTask.updateService(
      notificationTitle: 'Fall Heart 专注中',
      notificationText: '剩余时间 ${_format(_remainingSeconds)}',
    );
  }

  String _format(int total) {
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    final s = total % 60;
    return '${_two(h)}:${_two(m)}:${_two(s)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}

class ForegroundServiceManager {
  static Future<void> init() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'fall_heart_focus',
        channelName: '专注前台服务',
        channelDescription: 'Fall Heart 专注期间保持前台运行',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
        showBadge: false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
      ),
    );
  }

  static Future<bool> get isRunning => FlutterForegroundTask.isRunningService;

  static Future<void> start({required int totalSeconds}) async {
    final result = await FlutterForegroundTask.startService(
      serviceId: 100,
      notificationTitle: 'Fall Heart 专注中',
      notificationText: '剩余时间 ${_format(totalSeconds)}',
      callback: startCallback,
      serviceTypes: [ForegroundServiceTypes.dataSync],
    );

    switch (result) {
      case ServiceRequestSuccess():
        debugPrint('前台服务启动成功');
      case ServiceRequestFailure(:final error):
        debugPrint('前台服务启动失败: $error');
    }
  }

  static Future<void> updateRemaining(
    int remainingSeconds, {
    bool paused = false,
  }) async {
    if (!await isRunning) return;

    final status = paused ? '（已暂停）' : '';
    await FlutterForegroundTask.updateService(
      notificationTitle: 'Fall Heart 专注中',
      notificationText: '剩余时间 ${_format(remainingSeconds)}$status',
    );

    // 同时把最新数据同步给 Service isolate
    FlutterForegroundTask.sendDataToTask(remainingSeconds);
  }

  static Future<void> stop() async {
    final result = await FlutterForegroundTask.stopService();
    switch (result) {
      case ServiceRequestSuccess():
        debugPrint('前台服务已停止');
      case ServiceRequestFailure(:final error):
        debugPrint('停止前台服务失败: $error');
    }
  }

  static String _format(int total) {
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    final s = total % 60;
    return '${_two(h)}:${_two(m)}:${_two(s)}';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
