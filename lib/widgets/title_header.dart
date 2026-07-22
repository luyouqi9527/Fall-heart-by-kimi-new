import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/poem_provider.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final poem = context.watch<PoemProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fall Heart',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showPoemDialog(context, poem),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  poem.sentence,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB0A89E),
                    height: 1.4,
                  ),
                ),
              ),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFFB0A89E),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPoemDialog(BuildContext context, PoemProvider poem) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          poem.source,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          poem.full,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('关闭', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: '${poem.sentence}\n${poem.source}\n${poem.full}'));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已复制到剪贴板')),
              );
            },
            child: const Text('复制'),
          ),
        ],
      ),
    );
  }
}
