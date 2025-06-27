import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class ArcadeScreen extends StatelessWidget {
  const ArcadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.arcadeLabel),
      ),
      body: const Center(
        child: Text(
          'Écran Borne d\'arcade',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}