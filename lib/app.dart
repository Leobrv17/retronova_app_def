import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/widgets/main_navigation.dart';

class ArcadeApp extends StatelessWidget {
  const ArcadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcade App',
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}