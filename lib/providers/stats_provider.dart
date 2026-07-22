import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsProvider extends ChangeNotifier {
  static const _kDate = 'fh_focus_date';
  static const _kMinutes = 'fh_focus_minutes';

  int _todayMinutes = 0;
  String? _savedDate;

  int get todayMinutes => _todayMinutes;
  int get todayWords => _todayMinutes * 28;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _savedDate = prefs.getString(_kDate);
    _todayMinutes = prefs.getInt(_kMinutes) ?? 0;
    _checkAndReset();
    notifyListeners();
  }

  Future<void> addMinutes(int minutes) async {
    _checkAndReset();
    if (minutes <= 0) return;
    _todayMinutes += minutes;
    await _save();
    notifyListeners();
  }

  void _checkAndReset() {
    final today = _todayString();
    if (_savedDate != today) {
      _savedDate = today;
      _todayMinutes = 0;
      _save();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDate, _todayString());
    await prefs.setInt(_kMinutes, _todayMinutes);
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${_two(now.month)}-${_two(now.day)}';
  }

  String _two(int v) => v.toString().padLeft(2, '0');
}
