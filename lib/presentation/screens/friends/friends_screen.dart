import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.friendsLabel),
      ),
      body: const Center(
        child: Text(
          'Écran Friends',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}