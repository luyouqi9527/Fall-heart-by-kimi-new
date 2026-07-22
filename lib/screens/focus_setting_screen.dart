import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/timer_provider.dart';
import '../utils/validator.dart';
import '../widgets/title_header.dart';
import 'focus_running_screen.dart';

class FocusSettingScreen extends StatefulWidget {
  const FocusSettingScreen({super.key});

  @override
  State<FocusSettingScreen> createState() => _FocusSettingScreenState();
}

class _FocusSettingScreenState extends State<FocusSettingScreen> {
  final _hCtrl = TextEditingController();
  final _mCtrl = TextEditingController();
  final _sCtrl = TextEditingController();

  @override
  void dispose() {
    _hCtrl.dispose();
    _mCtrl.dispose();
    _sCtrl.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final error = Validator.validateHms(_hCtrl.text, _mCtrl.text, _sCtrl.text);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    final timer = context.read<TimerProvider>();
    try {
      await timer.start(
        hours: int.parse(_hCtrl.text),
        minutes: int.parse(_mCtrl.text),
        seconds: int.parse(_sCtrl.text),
      );

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const FocusRunningScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('未获得通知权限，无法开始专注')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleHeader(),
          const SizedBox(height: 32),
          const Text(
            '设定专注时长',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildField(_hCtrl, '时'),
              const SizedBox(width: 12),
              _buildField(_mCtrl, '分'),
              const SizedBox(width: 12),
              _buildField(_sCtrl, '秒'),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _start,
              child: const Text('开始专注'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}
