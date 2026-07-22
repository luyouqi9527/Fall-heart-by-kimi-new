import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/poem_provider.dart';
import '../providers/stats_provider.dart';
import '../widgets/title_header.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();
    final poem = context.watch<PoemProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleHeader(),
          const SizedBox(height: 28),
          _buildCard(
            title: '今日已专注',
            value: '${stats.todayMinutes}',
            unit: '分钟',
            sub: '相当于写了 ${stats.todayWords} 字',
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: '今日寄语',
            value: poem.sentence,
            unit: '',
            sub: '点击顶部诗句查看完整出处',
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required String unit,
    required String sub,
  }) {
    return Card(
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFB0A89E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
