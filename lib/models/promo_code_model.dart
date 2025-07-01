// lib/models/promo_code_model.dart
class PromoCodeUseResponse {
  final int ticketsReceived;
  final int newBalance;
  final String message;

  PromoCodeUseResponse({
    required this.ticketsReceived,
    required this.newBalance,
    required this.message,
  });

  factory PromoCodeUseResponse.fromJson(Map<String, dynamic> json) {
    return PromoCodeUseResponse(
      ticketsReceived: json['tickets_received'],
      newBalance: json['new_balance'],
      message: json['message'],
    );
  }
}

class PromoCodeHistoryItem {
  final int id;
  final String code;
  final int ticketsReceived;
  final DateTime usedAt;

  PromoCodeHistoryItem({
    required this.id,
    required this.code,
    required this.ticketsReceived,
    required this.usedAt,
  });

  factory PromoCodeHistoryItem.fromJson(Map<String, dynamic> json) {
    return PromoCodeHistoryItem(
      id: json['id'],
      code: json['code'],
      ticketsReceived: json['tickets_received'],
      usedAt: DateTime.parse(json['used_at']),
    );
  }
}