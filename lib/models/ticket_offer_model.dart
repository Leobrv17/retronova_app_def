// lib/models/ticket_offer_model.dart
class TicketOfferModel {
  final int id;
  final int ticketsAmount;
  final double priceEuros;
  final String name;

  TicketOfferModel({
    required this.id,
    required this.ticketsAmount,
    required this.priceEuros,
    required this.name,
  });

  factory TicketOfferModel.fromJson(Map<String, dynamic> json) {
    return TicketOfferModel(
      id: json['id'],
      ticketsAmount: json['tickets_amount'],
      priceEuros: json['price_euros'].toDouble(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tickets_amount': ticketsAmount,
      'price_euros': priceEuros,
      'name': name,
    };
  }

  // Calculer le prix par ticket
  double get pricePerTicket => priceEuros / ticketsAmount;

  // Calculer les économies par rapport au prix de base (2€ par ticket)
  double get savings {
    const basePricePerTicket = 2.0;
    final normalPrice = ticketsAmount * basePricePerTicket;
    return normalPrice - priceEuros;
  }

  // Pourcentage d'économie
  double get savingsPercentage {
    const basePricePerTicket = 2.0;
    final normalPrice = ticketsAmount * basePricePerTicket;
    if (normalPrice == 0) return 0;
    return (savings / normalPrice) * 100;
  }

  // Déterminer si c'est une bonne affaire
  bool get isGoodDeal => savingsPercentage > 0;
}

