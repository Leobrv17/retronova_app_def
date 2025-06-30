// lib/services/friend_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../core/config/api_config.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';

class FriendService {
  static final FriendService _instance = FriendService._internal();
  factory FriendService() => _instance;
  FriendService._internal();

  // Obtenir le token Firebase de l'utilisateur actuel
  Future<String?> _getFirebaseToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Récupérer la liste des amis
  Future<List<FriendModel>> getFriends() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/friends/'),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FriendModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des amis');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer les demandes d'amitié reçues
  Future<List<FriendshipModel>> getFriendRequests() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/friends/requests'),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FriendshipModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des demandes');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Rechercher des utilisateurs
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');
      print(Uri.encodeComponent(query));
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/search?q=${Uri.encodeComponent(query)}'),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la recherche');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Envoyer une demande d'amitié
  Future<void> sendFriendRequest(int userId) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/friends/request'),
        headers: ApiConfig.getHeaders(token: token),
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de l\'envoi de la demande');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Accepter une demande d'amitié
  Future<void> acceptFriendRequest(int friendshipId) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/friends/request/$friendshipId/accept'),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de l\'acceptation');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Rejeter une demande d'amitié
  Future<void> rejectFriendRequest(int friendshipId) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/friends/request/$friendshipId/reject'),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors du rejet');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Supprimer un ami
  Future<void> removeFriend(int userId) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/friends/$userId'),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de la suppression');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}