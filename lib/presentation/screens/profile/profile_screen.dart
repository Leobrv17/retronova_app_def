import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileLabel),
      ),
      body: const Center(
        child: Text(
          'Écran Profile',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}