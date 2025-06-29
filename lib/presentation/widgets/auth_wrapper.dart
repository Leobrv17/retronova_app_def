// lib/presentation/widgets/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import 'main_navigation.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();

    // Forcer la vérification de l'état d'authentification au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.checkAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print('AuthWrapper building - isLoading: ${authProvider.isLoading}, isAuthenticated: ${authProvider.isAuthenticated}'); // Debug

        // Si l'utilisateur est connecté, afficher l'application principale
        if (authProvider.isAuthenticated && !authProvider.isLoading) {
          print('User is authenticated, showing main app'); // Debug
          return const MainNavigation();
        }

        // Écran de chargement
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
                  SizedBox(height: 16),
                  Text(
                    'Connexion en cours...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Sinon, afficher l'écran de connexion
        print('User not authenticated, showing login'); // Debug
        return const LoginScreen();
      },
    );
  }
}