import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/foreground_service.dart';
import '../services/notification_helper.dart';
import 'stats_provider.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;

  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  int _plannedMinutes = 0;

  bool _isRunning = false;
  bool _isPaused = false;
  bool _completed = false;

  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  bool get completed => _completed;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;

  StatsProvider? _stats;
  set statsProvider(StatsProvider stats) => _stats = stats;

  Future<void> start({
    required int hours,
    required int minutes,
    required int seconds,
  }) async {
    if (_isRunning) return;

    final total = hours * 3600 + minutes * 60 + seconds;
    if (total <= 0) return;

    final perm = await NotificationHelper.requestPermission();
    if (perm != NotificationPermission.granted) {
      throw Exception('需要通知权限才能开始专注');
    }

    _totalSeconds = total;
    _remainingSeconds = total;
    _plannedMinutes = total ~/ 60;
    _isRunning = true;
    _isPaused = false;
    _completed = false;

    notifyListeners();

    await ForegroundServiceManager.start(totalSeconds: total);
    await ForegroundServiceManager.updateRemaining(_remainingSeconds);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (!_isRunning) return;

    if (!_isPaused && _remainingSeconds > 0) {
      _remainingSeconds--;
      ForegroundServiceManager.updateRemaining(_remainingSeconds, paused: false);
      notifyListeners();

      if (_remainingSeconds == 0) {
        _complete();
      }
    } else if (_isPaused) {
      ForegroundServiceManager.updateRemaining(_remainingSeconds, paused: true);
    }
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
    ForegroundServiceManager.updateRemaining(_remainingSeconds, paused: _isPaused);
  }

  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;
    _completed = false;
    notifyListeners();
    await ForegroundServiceManager.stop();
  }

  Future<void> _complete() async {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;
    _completed = true;
    notifyListeners();

    await ForegroundServiceManager.stop();

    if (_stats != null && _plannedMinutes > 0) {
      await _stats!.addMinutes(_plannedMinutes);
    }

    await NotificationHelper.showCompletionNotification();
    HapticFeedback.vibrate();
  }
}
