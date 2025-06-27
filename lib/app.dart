import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/widgets/auth_wrapper.dart';

class ArcadeApp extends StatelessWidget {
  const ArcadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retronova App',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}