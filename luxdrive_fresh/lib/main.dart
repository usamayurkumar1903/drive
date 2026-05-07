// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/car_provider.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: LuxDriveApp()));
}

class LuxDriveApp extends ConsumerWidget {
  const LuxDriveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      data: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: MaterialApp(
        title: 'LuxDrive',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
