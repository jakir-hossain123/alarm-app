import 'package:alarm_app/core/services/service_locator.dart';
import 'package:alarm_app/core/theme/app_theme.dart';
import 'package:alarm_app/presentasion/providers/alarm_provider.dart';
import 'package:alarm_app/presentasion/providers/navigation_provider.dart';
import 'package:alarm_app/presentasion/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ServiceLocator.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AlarmProvider(
            ServiceLocator.alarmRepository,
          )..loadAlarms(),
        ),
      ],
      child: const AlarmApp(),
    ),
  );
}

class AlarmApp extends StatelessWidget {
  const AlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
    );
  }
}