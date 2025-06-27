import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import 'main_navigation.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Écran de chargement initial
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_esports,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Retronova',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 32),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ],
              ),
            ),
          );
        }

        // Si l'utilisateur est connecté, afficher l'application principale
        if (authProvider.isAuthenticated) {
          return const MainNavigation();
        }

        // Sinon, afficher l'écran de connexion
        return const LoginScreen();
      },
    );
  }
}