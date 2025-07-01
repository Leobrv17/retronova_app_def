// lib/providers/score_provider.dart
import 'package:flutter/foundation.dart';
import '../models/score_model.dart';
import '../models/game_model.dart';
import '../models/arcade_model.dart';
import '../services/score_service.dart';

class ScoreProvider with ChangeNotifier {
  final ScoreService _scoreService = ScoreService();

  List<ScoreModel> _scores = [];
  PlayerStatsModel? _myStats;
  List<GameModel> _availableGames = [];
  List<ArcadeModel> _availableArcades = [];

  bool _isLoading = false;
  bool _isLoadingStats = false;
  String? _errorMessage;

  // Filtres
  int? _selectedGameId;
  int? _selectedArcadeId;
  bool _friendsOnly = false;
  bool _singlePlayerOnly = false;
  int _limit = 50;

  // Getters
  List<ScoreModel> get scores => _scores;
  PlayerStatsModel? get myStats => _myStats;
  List<GameModel> get availableGames => _availableGames;
  List<ArcadeModel> get availableArcades => _availableArcades;
  bool get isLoading => _isLoading;
  bool get isLoadingStats => _isLoadingStats;
  String? get errorMessage => _errorMessage;

  // Getters pour les filtres
  int? get selectedGameId => _selectedGameId;
  int? get selectedArcadeId => _selectedArcadeId;
  bool get friendsOnly => _friendsOnly;
  bool get singlePlayerOnly => _singlePlayerOnly;
  int get limit => _limit;

  // Getter pour savoir si des filtres sont actifs
  bool get hasActiveFilters =>
      _selectedGameId != null ||
          _selectedArcadeId != null ||
          _friendsOnly ||
          _singlePlayerOnly;

  // Charger les scores avec les filtres actuels
  Future<void> loadScores() async {
    try {
      _setLoading(true);
      _clearError();

      _scores = await _scoreService.getScores(
        gameId: _selectedGameId,
        arcadeId: _selectedArcadeId,
        friendsOnly: _friendsOnly,
        singlePlayerOnly: _singlePlayerOnly,
        limit: _limit,
      );

      print('ScoreProvider: Loaded ${_scores.length} scores');
      notifyListeners();
    } catch (e) {
      print('ScoreProvider error loading scores: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Charger les statistiques personnelles
  Future<void> loadMyStats() async {
    try {
      _setLoadingStats(true);
      _clearError();

      _myStats = await _scoreService.getMyStats();
      print('ScoreProvider: Loaded personal stats');
      notifyListeners();
    } catch (e) {
      print('ScoreProvider error loading stats: $e');
      _setError(e.toString());
    } finally {
      _setLoadingStats(false);
    }
  }

  // Définir les jeux disponibles (appelé depuis ArcadeProvider)
  void setAvailableGames(List<GameModel> games) {
    _availableGames = games;
    notifyListeners();
  }

  // Définir les bornes disponibles (appelé depuis ArcadeProvider)
  void setAvailableArcades(List<ArcadeModel> arcades) {
    _availableArcades = arcades;
    notifyListeners();
  }

  // Méthodes pour gérer les filtres
  void setGameFilter(int? gameId) {
    if (_selectedGameId != gameId) {
      _selectedGameId = gameId;
      _reloadWithFilters();
    }
  }

  void setArcadeFilter(int? arcadeId) {
    if (_selectedArcadeId != arcadeId) {
      _selectedArcadeId = arcadeId;
      _reloadWithFilters();
    }
  }

  void setFriendsOnlyFilter(bool friendsOnly) {
    if (_friendsOnly != friendsOnly) {
      _friendsOnly = friendsOnly;
      _reloadWithFilters();
    }
  }

  void setSinglePlayerOnlyFilter(bool singlePlayerOnly) {
    if (_singlePlayerOnly != singlePlayerOnly) {
      _singlePlayerOnly = singlePlayerOnly;
      _reloadWithFilters();
    }
  }

  void setLimit(int limit) {
    if (_limit != limit) {
      _limit = limit;
      _reloadWithFilters();
    }
  }

  // Supprimer tous les filtres
  void clearAllFilters() {
    final hasChanges = _selectedGameId != null ||
        _selectedArcadeId != null ||
        _friendsOnly ||
        _singlePlayerOnly;

    if (hasChanges) {
      _selectedGameId = null;
      _selectedArcadeId = null;
      _friendsOnly = false;
      _singlePlayerOnly = false;
      _reloadWithFilters();
    }
  }

  // Supprimer un filtre spécifique
  void clearGameFilter() => setGameFilter(null);
  void clearArcadeFilter() => setArcadeFilter(null);
  void clearFriendsOnlyFilter() => setFriendsOnlyFilter(false);
  void clearSinglePlayerOnlyFilter() => setSinglePlayerOnlyFilter(false);

  // Recharger avec les filtres actuels
  void _reloadWithFilters() {
    loadScores();
  }

  // Rafraîchir toutes les données
  Future<void> refresh() async {
    await Future.wait([
      loadScores(),
      loadMyStats(),
    ]);
  }

  // Trouver un jeu par ID
  GameModel? findGameById(int gameId) {
    try {
      return _availableGames.firstWhere((game) => game.id == gameId);
    } catch (e) {
      return null;
    }
  }

  // Trouver une borne par ID
  ArcadeModel? findArcadeById(int arcadeId) {
    try {
      return _availableArcades.firstWhere((arcade) => arcade.id == arcadeId);
    } catch (e) {
      return null;
    }
  }

  // Obtenir les scores récents (dernières 24h)
  List<ScoreModel> get recentScores {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _scores.where((score) => score.createdAt.isAfter(yesterday)).toList();
  }

  // Obtenir les meilleurs scores (top 10)
  List<ScoreModel> get topScores {
    final sortedScores = List<ScoreModel>.from(_scores);
    sortedScores.sort((a, b) {
      // Pour les jeux solo, trier par score du joueur 1
      if (a.isSinglePlayer && b.isSinglePlayer) {
        return b.scoreJ1.compareTo(a.scoreJ1);
      }
      // Pour les jeux multijoueur, on peut prendre le score max entre les deux joueurs
      final aMaxScore = a.isSinglePlayer ? a.scoreJ1 :
      (a.scoreJ2 != null ? [a.scoreJ1, a.scoreJ2!].reduce((a, b) => a > b ? a : b) : a.scoreJ1);
      final bMaxScore = b.isSinglePlayer ? b.scoreJ1 :
      (b.scoreJ2 != null ? [b.scoreJ1, b.scoreJ2!].reduce((a, b) => a > b ? a : b) : b.scoreJ1);
      return bMaxScore.compareTo(aMaxScore);
    });
    return sortedScores.take(10).toList();
  }

  // Obtenir le nombre de filtres actifs
  int get activeFilterCount {
    int count = 0;
    if (_selectedGameId != null) count++;
    if (_selectedArcadeId != null) count++;
    if (_friendsOnly) count++;
    if (_singlePlayerOnly) count++;
    return count;
  }

  // Méthodes utilitaires
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingStats(bool loading) {
    _isLoadingStats = loading;
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