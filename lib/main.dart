import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';

import 'providers/poem_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/timer_provider.dart';
import 'screens/home_screen.dart';
import 'services/foreground_service.dart';
import 'services/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 初始化前台任务通信端口
  FlutterForegroundTask.initCommunicationPort();

  // 2. 初始化通知与前台服务
  await NotificationHelper.init();
  await ForegroundServiceManager.init();

  // 3. 加载古诗与今日数据
  final poemProvider = PoemProvider();
  await poemProvider.loadPoems();

  final statsProvider = StatsProvider();
  await statsProvider.load();

  final timerProvider = TimerProvider()..statsProvider = statsProvider;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PoemProvider>.value(value: poemProvider),
        ChangeNotifierProvider<StatsProvider>.value(value: statsProvider),
        ChangeNotifierProvider<TimerProvider>.value(value: timerProvider),
      ],
      child: const FallHeartApp(),
    ),
  );
}

class FallHeartApp extends StatelessWidget {
  const FallHeartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fall Heart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB0A89E),
          brightness: Brightness.dark,
          surface: const Color(0xFF1A1A1A),
        ).copyWith(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: const Color(0xFFB0A89E),
          onSecondary: Colors.black,
          surface: const Color(0xFF1A1A1A),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        cardTheme: CardTheme(
          color: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const WithForegroundTask(child: HomeScreen()),
    );
  }
}
