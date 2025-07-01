// lib/services/score_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../core/config/api_config.dart';
import '../models/score_model.dart';

class ScoreService {
  static final ScoreService _instance = ScoreService._internal();
  factory ScoreService() => _instance;
  ScoreService._internal();

  // Obtenir le token Firebase de l'utilisateur actuel
  Future<String?> _getFirebaseToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Récupérer les scores avec filtres
  Future<List<ScoreModel>> getScores({
    int? gameId,
    int? arcadeId,
    bool friendsOnly = false,
    bool singlePlayerOnly = false,
    int limit = 50,
  }) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      // Construire l'URL avec les paramètres de requête
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };

      if (gameId != null) {
        queryParams['game_id'] = gameId.toString();
      }

      if (arcadeId != null) {
        queryParams['arcade_id'] = arcadeId.toString();
      }

      if (friendsOnly) {
        queryParams['friends_only'] = 'true';
      }

      if (singlePlayerOnly) {
        queryParams['single_player_only'] = 'true';
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}/scores/').replace(
        queryParameters: queryParams,
      );

      print('Scores request URL: $uri');

      final response = await http.get(
        uri,
        headers: ApiConfig.getHeaders(token: token),
      );

      print('Scores response status: ${response.statusCode}');
      print('Scores response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ScoreModel.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de la récupération des scores');
      }
    } catch (e) {
      print('Error in getScores: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer les statistiques personnelles
  Future<PlayerStatsModel> getMyStats() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/scores/my-stats'),
        headers: ApiConfig.getHeaders(token: token),
      );

      print('My stats response status: ${response.statusCode}');
      print('My stats response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PlayerStatsModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de la récupération des statistiques');
      }
    } catch (e) {
      print('Error in getMyStats: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
}