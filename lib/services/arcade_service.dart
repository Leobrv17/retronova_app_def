// lib/services/arcade_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../core/config/api_config.dart';
import '../models/arcade_model.dart';
import '../models/game_model.dart';
import '../models/reservation_model.dart';

class ArcadeService {
  static final ArcadeService _instance = ArcadeService._internal();
  factory ArcadeService() => _instance;
  ArcadeService._internal();

  // Obtenir le token Firebase de l'utilisateur actuel
  Future<String?> _getFirebaseToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Récupérer toutes les bornes d'arcade
  Future<List<ArcadeModel>> getArcades() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/arcades/'),
        headers: ApiConfig.getHeaders(),
      );

      print('Arcades response status: ${response.statusCode}');
      print('Arcades response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ArcadeModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des bornes');
      }
    } catch (e) {
      print('Error in getArcades: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer une borne spécifique par ID
  Future<ArcadeModel> getArcadeById(int arcadeId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/arcades/$arcadeId'),
        headers: ApiConfig.getHeaders(),
      );

      print('Arcade detail response status: ${response.statusCode}');
      print('Arcade detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ArcadeModel.fromJson(data);
      } else {
        throw Exception('Erreur lors de la récupération de la borne');
      }
    } catch (e) {
      print('Error in getArcadeById: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer tous les jeux
  Future<List<GameModel>> getGames() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/games/'),
        headers: ApiConfig.getHeaders(),
      );

      print('Games response status: ${response.statusCode}');
      print('Games response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => GameModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des jeux');
      }
    } catch (e) {
      print('Error in getGames: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Créer une réservation
  Future<ReservationModel> createReservation({
    required int arcadeId,
    required int gameId,
    int? player2Id,
  }) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final body = <String, dynamic>{
        'arcade_id': arcadeId,
        'game_id': gameId,
      };

      if (player2Id != null) {
        body['player2_id'] = player2Id;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/reservations/'),
        headers: ApiConfig.getHeaders(token: token),
        body: jsonEncode(body),
      );

      print('Reservation response status: ${response.statusCode}');
      print('Reservation response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ReservationModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de la création de la réservation');
      }
    } catch (e) {
      print('Error in createReservation: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer les réservations de l'utilisateur
  Future<List<ReservationModel>> getMyReservations() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/reservations/'),
        headers: ApiConfig.getHeaders(token: token),
      );

      print('My reservations response status: ${response.statusCode}');
      print('My reservations response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ReservationModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des réservations');
      }
    } catch (e) {
      print('Error in getMyReservations: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Annuler une réservation
  Future<void> cancelReservation(int reservationId) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/reservations/$reservationId'),
        headers: ApiConfig.getHeaders(token: token),
      );

      print('Cancel reservation response status: ${response.statusCode}');
      print('Cancel reservation response body: ${response.body}');

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de l\'annulation');
      }
    } catch (e) {
      print('Error in cancelReservation: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer une réservation spécifique
  Future<ReservationModel> getReservationById(int reservationId) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/reservations/$reservationId'),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ReservationModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de la récupération de la réservation');
      }
    } catch (e) {
      print('Error in getReservationById: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
}