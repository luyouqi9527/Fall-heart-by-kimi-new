String formatSeconds(int total) {
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = total % 60;
  return '${_two(h)}:${_two(m)}:${_two(s)}';
}

String _two(int n) => n.toString().padLeft(2, '0');
