// lib/services/ticket_service.dart - Version étendue
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../core/config/api_config.dart';
import '../models/ticket_offer_model.dart';
import '../models/ticket_purchase_model.dart';
import '../models/promo_code_model.dart';

class TicketService {
  static final TicketService _instance = TicketService._internal();
  factory TicketService() => _instance;
  TicketService._internal();

  // Obtenir le token Firebase de l'utilisateur actuel
  Future<String?> _getFirebaseToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Récupérer toutes les offres de tickets
  Future<List<TicketOfferModel>> getTicketOffers() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tickets/offers'),
        headers: ApiConfig.getHeaders(),
      );

      print('Ticket offers response status: ${response.statusCode}');
      print('Ticket offers response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TicketOfferModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des offres');
      }
    } catch (e) {
      print('Error in getTicketOffers: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Acheter des tickets
  Future<Map<String, dynamic>> purchaseTickets(int offerId) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tickets/purchase'),
        headers: ApiConfig.getHeaders(token: token),
        body: jsonEncode({'offer_id': offerId}),
      );

      print('Purchase response status: ${response.statusCode}');
      print('Purchase response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de l\'achat');
      }
    } catch (e) {
      print('Error in purchaseTickets: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer le solde de tickets
  Future<int> getTicketBalance() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tickets/balance'),
        headers: ApiConfig.getHeaders(token: token),
      );

      print('Balance response status: ${response.statusCode}');
      print('Balance response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['balance'] ?? 0;
      } else {
        throw Exception('Erreur lors de la récupération du solde');
      }
    } catch (e) {
      print('Error in getTicketBalance: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer l'historique des achats
  Future<List<TicketPurchaseModel>> getPurchaseHistory() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tickets/history'),
        headers: ApiConfig.getHeaders(token: token),
      );

      print('History response status: ${response.statusCode}');
      print('History response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TicketPurchaseModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération de l\'historique');
      }
    } catch (e) {
      print('Error in getPurchaseHistory: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // NOUVELLES MÉTHODES POUR LES CODES PROMO

  // Utiliser un code promo
  Future<PromoCodeUseResponse> usePromoCode(String code) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/promos/use'),
        headers: ApiConfig.getHeaders(token: token),
        body: jsonEncode({'code': code}),
      );

      print('Promo use response status: ${response.statusCode}');
      print('Promo use response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PromoCodeUseResponse.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erreur lors de l\'utilisation du code promo');
      }
    } catch (e) {
      print('Error in usePromoCode: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupérer l'historique des codes promo utilisés
  Future<List<PromoCodeHistoryItem>> getPromoHistory() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) throw Exception('Token Firebase non disponible');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/promos/history'),
        headers: ApiConfig.getHeaders(token: token),
      );

      print('Promo history response status: ${response.statusCode}');
      print('Promo history response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PromoCodeHistoryItem.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération de l\'historique des codes promo');
      }
    } catch (e) {
      print('Error in getPromoHistory: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
}