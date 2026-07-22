import 'dart:math';
import 'package:flutter/material.dart';

import '../models/poem.dart';
import '../utils/poem_loader.dart';

class PoemProvider extends ChangeNotifier {
  List<Poem> _poems = [];
  Poem _current = const Poem(
    sentence: '一寸光阴一寸金，寸金难买寸光阴',
    source: '佚名',
    full: '一寸光阴一寸金，寸金难买寸光阴。',
  );
  bool _loaded = false;

  Poem get current => _current;
  String get sentence => _current.sentence;
  String get source => _current.source;
  String get full => _current.full;

  Future<void> loadPoems() async {
    if (_loaded) return;
    _poems = await PoemLoader.load();
    if (_poems.isNotEmpty) {
      _current = _poems[Random().nextInt(_poems.length)];
      _loaded = true;
    }
    notifyListeners();
  }

  void refresh() {
    if (_poems.isNotEmpty) {
      _current = _poems[Random().nextInt(_poems.length)];
      notifyListeners();
    }
  }
}
