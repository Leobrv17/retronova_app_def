// lib/models/ticket_purchase_model.dart
class TicketPurchaseModel {
  final int id;
  final int ticketsReceived;
  final double amountPaid;
  final DateTime createdAt;
  final String? stripePaymentId;

  TicketPurchaseModel({
    required this.id,
    required this.ticketsReceived,
    required this.amountPaid,
    required this.createdAt,
    this.stripePaymentId,
  });

  factory TicketPurchaseModel.fromJson(Map<String, dynamic> json) {
    return TicketPurchaseModel(
      id: json['id'],
      ticketsReceived: json['tickets_received'],
      amountPaid: json['amount_paid'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      stripePaymentId: json['stripe_payment_id'],
    );
  }
}