// lib/providers/auth_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  StreamSubscription<User?>? _authStateSubscription;

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  // Initialiser l'authentification
  void _initializeAuth() {
    try {
      // Écouter les changements d'état d'authentification
      _authStateSubscription = _authService.authStateChanges.listen(
        _onAuthStateChanged,
        onError: (error) {
          _setError('Erreur d\'authentification: $error');
          _setLoading(false);
        },
      );
    } catch (e) {
      _setError('Erreur d\'initialisation: $e');
      _setLoading(false);
    }
  }

  // Gestion des changements d'état d'authentification
  void _onAuthStateChanged(User? user) async {
    try {
      print('Auth state changed: ${user?.uid}'); // Debug

      _user = user;
      _clearError();

      // Si vous voulez intégrer votre API plus tard,
      // c'est ici que vous pourrez charger les données utilisateur
      if (user != null) {
        print('User authenticated: ${user.email}'); // Debug
        // TODO: Intégrer votre API ici
        // await _loadUserDataFromYourAPI();
      } else {
        print('User signed out'); // Debug
      }
    } catch (e) {
      _setError('Erreur lors du chargement: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Inscription
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return _performAuthAction(() async {
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      // Attendre un peu que l'état se mette à jour
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    });
  }

  // Connexion
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    return _performAuthAction(() async {
      // Vérifier si l'utilisateur est déjà connecté avec le même email
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.email == email) {
        print('User already signed in with this email: ${currentUser.email}');
        return true; // Considérer comme un succès
      }

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Attendre un peu que l'état se mette à jour
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    });
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      print('User signed out manually'); // Debug
    } catch (e) {
      _setError('Erreur lors de la déconnexion: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Réinitialisation du mot de passe
  Future<bool> resetPassword(String email) async {
    return _performAuthAction(() async {
      await _authService.resetPassword(email);
      return true;
    });
  }

  // Méthode utilitaire pour gérer les actions d'authentification avec timeout
  Future<bool> _performAuthAction(Future<bool> Function() action) async {
    try {
      _setLoading(true);
      _clearError();

      // Utiliser un Completer pour gérer le timeout manuellement
      final completer = Completer<bool>();
      late Timer timeoutTimer;

      // Démarrer l'action
      action().then((result) {
        if (!completer.isCompleted) {
          timeoutTimer.cancel();
          completer.complete(result);
        }
      }).catchError((error) {
        if (!completer.isCompleted) {
          timeoutTimer.cancel();
          completer.completeError(error);
        }
      });

      // Démarrer le timer de timeout
      timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('Timeout', const Duration(seconds: 30)));
        }
      });

      return await completer.future;
    } catch (e) {
      if (e is TimeoutException) {
        _setError('L\'opération a pris trop de temps. Veuillez réessayer.');
      } else {
        _setError(e.toString());
      }
      return false;
    } finally {
      // Ne pas arrêter le loading ici car _onAuthStateChanged le fera
      // _setLoading(false);
    }
  }

  // Gestion des états
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      print('Auth loading state: $loading'); // Debug
      notifyListeners();
    }
  }

  void _setError(String error) {
    _errorMessage = error;
    print('AuthProvider Error: $error');
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Nettoyer l'erreur manuellement
  void clearError() {
    _clearError();
  }

  // Forcer la vérification de l'état actuel
  void checkAuthState() {
    final currentUser = FirebaseAuth.instance.currentUser;
    _onAuthStateChanged(currentUser);
  }
}