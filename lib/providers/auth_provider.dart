import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Écouter les changements d'état d'authentification
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  // Gestion des changements d'état d'authentification
  void _onAuthStateChanged(User? user) async {
    _user = user;
    _clearError();

    if (user != null) {
      await _loadUserData();
      await _authService.updateLastLogin();
    } else {
      _userData = null;
    }

    notifyListeners();
  }

  // Charger les données utilisateur
  Future<void> _loadUserData() async {
    try {
      _userData = await _authService.getUserData();
    } catch (e) {
      _setError('Erreur lors du chargement des données utilisateur');
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
      return true;
    });
  }

  // Connexion
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    return _performAuthAction(() async {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    });
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
    } catch (e) {
      _setError('Erreur lors de la déconnexion');
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

  // Méthode utilitaire pour gérer les actions d'authentification
  Future<bool> _performAuthAction(Future<bool> Function() action) async {
    try {
      _setLoading(true);
      _clearError();
      return await action();
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Gestion des états
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Nettoyer l'erreur manuellement
  void clearError() {
    _clearError();
  }
}