import 'package:flutter/services.dart' show rootBundle;

import '../models/poem.dart';

class PoemLoader {
  static Future<List<Poem>> load() async {
    final raw = await rootBundle.loadString('assets/poems.txt');
    final lines = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return lines.map((line) {
      final parts = line.split('|');
      if (parts.length >= 3) {
        return Poem(
          sentence: parts[0].trim(),
          source: parts[1].trim(),
          full: parts[2].trim(),
        );
      } else if (parts.length == 2) {
        return Poem(
          sentence: parts[0].trim(),
          source: parts[1].trim(),
          full: parts[0].trim(),
        );
      } else {
        return Poem(
          sentence: line,
          source: '佚名',
          full: line,
        );
      }
    }).toList();
  }
}
