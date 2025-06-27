import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.storeLabel),
      ),
      body: const Center(
        child: Text(
          'Écran Store',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}