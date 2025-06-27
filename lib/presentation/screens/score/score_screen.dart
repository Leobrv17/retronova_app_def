import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.scoreLabel),
      ),
      body: const Center(
        child: Text(
          'Écran Score',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}