// lib/providers/arcade_provider.dart
import 'package:flutter/foundation.dart';
import '../models/arcade_model.dart';
import '../models/game_model.dart';
import '../models/reservation_model.dart';
import '../services/arcade_service.dart';

class ArcadeProvider with ChangeNotifier {
  final ArcadeService _arcadeService = ArcadeService();

  List<ArcadeModel> _arcades = [];
  List<GameModel> _games = [];
  List<ReservationModel> _myReservations = [];
  List<ArcadeModel> _filteredArcades = [];

  bool _isLoading = false;
  bool _isLoadingReservations = false;
  bool _isCreatingReservation = false;
  String? _errorMessage;
  String _searchQuery = '';

  // Getters
  List<ArcadeModel> get arcades => _filteredArcades.isNotEmpty || _searchQuery.isNotEmpty
      ? _filteredArcades
      : _arcades;
  List<GameModel> get games => _games;
  List<ReservationModel> get myReservations => _myReservations;
  bool get isLoading => _isLoading;
  bool get isLoadingReservations => _isLoadingReservations;
  bool get isCreatingReservation => _isCreatingReservation;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // Statistiques des réservations
  List<ReservationModel> get activeReservations =>
      _myReservations.where((r) => r.isWaiting || r.isPlaying).toList();

  List<ReservationModel> get waitingReservations =>
      _myReservations.where((r) => r.isWaiting).toList();

  int get totalActiveReservations => activeReservations.length;

  // Charger toutes les bornes d'arcade
  Future<void> loadArcades() async {
    try {
      _setLoading(true);
      _clearError();

      _arcades = await _arcadeService.getArcades();
      _applySearchFilter();

      print('ArcadeProvider: Loaded ${_arcades.length} arcades');
      notifyListeners();
    } catch (e) {
      print('ArcadeProvider error loading arcades: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Charger tous les jeux
  Future<void> loadGames() async {
    try {
      _clearError();
      _games = await _arcadeService.getGames();
      print('ArcadeProvider: Loaded ${_games.length} games');
      notifyListeners();
    } catch (e) {
      print('ArcadeProvider error loading games: $e');
      _setError(e.toString());
    }
  }

  // Rechercher des bornes
  void searchArcades(String query) {
    _searchQuery = query.toLowerCase().trim();
    _applySearchFilter();
    notifyListeners();
  }

  // Appliquer le filtre de recherche
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredArcades = [];
      return;
    }

    _filteredArcades = _arcades.where((arcade) {
      return arcade.nom.toLowerCase().contains(_searchQuery) ||
          arcade.localisation.toLowerCase().contains(_searchQuery) ||
          arcade.description.toLowerCase().contains(_searchQuery) ||
          arcade.games.any((game) =>
              game.nom.toLowerCase().contains(_searchQuery));
    }).toList();

    // Trier par pertinence (nom en premier, puis localisation)
    _filteredArcades.sort((a, b) {
      final aNameMatch = a.nom.toLowerCase().contains(_searchQuery);
      final bNameMatch = b.nom.toLowerCase().contains(_searchQuery);

      if (aNameMatch && !bNameMatch) return -1;
      if (!aNameMatch && bNameMatch) return 1;

      return a.nom.compareTo(b.nom);
    });
  }

  // Vider la recherche
  void clearSearch() {
    _searchQuery = '';
    _filteredArcades = [];
    notifyListeners();
  }

  // Récupérer une borne par ID
  Future<ArcadeModel?> getArcadeById(int arcadeId) async {
    try {
      // D'abord chercher dans la liste locale
      try {
        final localArcade = _arcades.firstWhere((a) => a.id == arcadeId);
        return localArcade;
      } catch (e) {
        // Si pas trouvé localement, charger depuis l'API
        return await _arcadeService.getArcadeById(arcadeId);
      }
    } catch (e) {
      print('ArcadeProvider error getting arcade by id: $e');
      _setError(e.toString());
      return null;
    }
  }

  // Charger les réservations de l'utilisateur
  Future<void> loadMyReservations() async {
    try {
      _setLoadingReservations(true);
      _clearError();

      _myReservations = await _arcadeService.getMyReservations();

      // Trier par date de création décroissante
      _myReservations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('ArcadeProvider: Loaded ${_myReservations.length} reservations');
      notifyListeners();
    } catch (e) {
      print('ArcadeProvider error loading reservations: $e');
      _setError(e.toString());
    } finally {
      _setLoadingReservations(false);
    }
  }

  // Créer une réservation
  Future<ReservationModel?> createReservation({
    required int arcadeId,
    required int gameId,
    int? player2Id,
  }) async {
    try {
      _setCreatingReservation(true);
      _clearError();

      final reservation = await _arcadeService.createReservation(
        arcadeId: arcadeId,
        gameId: gameId,
        player2Id: player2Id,
      );

      // Ajouter la nouvelle réservation à la liste
      _myReservations.insert(0, reservation);

      print('ArcadeProvider: Created reservation ${reservation.id}');
      notifyListeners();

      return reservation;
    } catch (e) {
      print('ArcadeProvider error creating reservation: $e');
      _setError(e.toString());
      return null;
    } finally {
      _setCreatingReservation(false);
    }
  }

  // Annuler une réservation
  Future<bool> cancelReservation(int reservationId) async {
    try {
      _clearError();

      await _arcadeService.cancelReservation(reservationId);

      // Mettre à jour la réservation localement
      final index = _myReservations.indexWhere((r) => r.id == reservationId);
      if (index != -1) {
        _myReservations.removeAt(index);
      }

      print('ArcadeProvider: Cancelled reservation $reservationId');
      notifyListeners();

      return true;
    } catch (e) {
      print('ArcadeProvider error cancelling reservation: $e');
      _setError(e.toString());
      return false;
    }
  }

  // Rafraîchir une réservation spécifique
  Future<void> refreshReservation(int reservationId) async {
    try {
      final updatedReservation = await _arcadeService.getReservationById(reservationId);

      final index = _myReservations.indexWhere((r) => r.id == reservationId);
      if (index != -1) {
        _myReservations[index] = updatedReservation;
        notifyListeners();
      }
    } catch (e) {
      print('ArcadeProvider error refreshing reservation: $e');
      // Ne pas afficher d'erreur pour le rafraîchissement automatique
    }
  }

  // Charger toutes les données
  Future<void> loadAllData() async {
    await Future.wait([
      loadArcades(),
      loadGames(),
      loadMyReservations(),
    ]);
  }

  // Rafraîchir toutes les données
  Future<void> refresh() async {
    await loadAllData();
  }

  // Filtrer les bornes par jeu
  List<ArcadeModel> getArcadesByGame(int gameId) {
    return _arcades.where((arcade) =>
        arcade.games.any((game) => game.id == gameId)).toList();
  }

  // Obtenir les jeux disponibles sur une borne
  List<GameOnArcadeModel> getGamesForArcade(int arcadeId) {
    try {
      final arcade = _arcades.firstWhere((a) => a.id == arcadeId);
      return arcade.games;
    } catch (e) {
      return [];
    }
  }

  // Méthodes utilitaires
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingReservations(bool loading) {
    _isLoadingReservations = loading;
    notifyListeners();
  }

  void _setCreatingReservation(bool creating) {
    _isCreatingReservation = creating;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}