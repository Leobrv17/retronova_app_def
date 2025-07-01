// lib/providers/ticket_provider.dart
import 'package:flutter/foundation.dart';
import '../models/ticket_offer_model.dart';
import '../models/ticket_purchase_model.dart';
import '../services/ticket_service.dart';

class TicketProvider with ChangeNotifier {
  final TicketService _ticketService = TicketService();

  List<TicketOfferModel> _offers = [];
  List<TicketPurchaseModel> _purchaseHistory = [];
  int _ticketBalance = 0;
  bool _isLoading = false;
  bool _isPurchasing = false;
  String? _errorMessage;

  // Getters
  List<TicketOfferModel> get offers => _offers;
  List<TicketPurchaseModel> get purchaseHistory => _purchaseHistory;
  int get ticketBalance => _ticketBalance;
  bool get isLoading => _isLoading;
  bool get isPurchasing => _isPurchasing;
  String? get errorMessage => _errorMessage;

  // Charger les offres de tickets
  Future<void> loadOffers() async {
    try {
      _setLoading(true);
      _clearError();

      _offers = await _ticketService.getTicketOffers();
      print('TicketProvider: Loaded ${_offers.length} offers');
      notifyListeners();
    } catch (e) {
      print('TicketProvider error loading offers: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Charger le solde de tickets
  Future<void> loadBalance() async {
    try {
      _clearError();
      _ticketBalance = await _ticketService.getTicketBalance();
      print('TicketProvider: Balance loaded: $_ticketBalance');
      notifyListeners();
    } catch (e) {
      print('TicketProvider error loading balance: $e');
      _setError(e.toString());
    }
  }

  // Acheter des tickets
  Future<bool> purchaseTickets(int offerId) async {
    try {
      _setPurchasing(true);
      _clearError();

      final result = await _ticketService.purchaseTickets(offerId);

      // Mettre à jour le solde avec la valeur retournée
      _ticketBalance = result['new_balance'] ?? _ticketBalance;

      print('TicketProvider: Purchase successful, new balance: $_ticketBalance');

      // Recharger l'historique
      await loadPurchaseHistory();

      notifyListeners();
      return true;
    } catch (e) {
      print('TicketProvider error purchasing tickets: $e');
      _setError(e.toString());
      return false;
    } finally {
      _setPurchasing(false);
    }
  }

  // Charger l'historique des achats
  Future<void> loadPurchaseHistory() async {
    try {
      _clearError();
      _purchaseHistory = await _ticketService.getPurchaseHistory();
      print('TicketProvider: Loaded ${_purchaseHistory.length} purchases');
      notifyListeners();
    } catch (e) {
      print('TicketProvider error loading history: $e');
      _setError(e.toString());
    }
  }

  // Charger toutes les données
  Future<void> loadAllData() async {
    await Future.wait([
      loadOffers(),
      loadBalance(),
      loadPurchaseHistory(),
    ]);
  }

  // Rafraîchir les données
  Future<void> refresh() async {
    await loadAllData();
  }

  // Méthodes utilitaires
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setPurchasing(bool purchasing) {
    _isPurchasing = purchasing;
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

  // Trouver une offre par ID
  TicketOfferModel? findOfferById(int id) {
    try {
      return _offers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      return null;
    }
  }

  // Calculer le total dépensé
  double get totalSpent {
    return _purchaseHistory.fold(0.0, (sum, purchase) => sum + purchase.amountPaid);
  }

  // Calculer le total de tickets achetés
  int get totalTicketsPurchased {
    return _purchaseHistory.fold(0, (sum, purchase) => sum + purchase.ticketsReceived);
  }
}