// lib/models/reservation_model.dart
enum ReservationStatus {
  waiting,
  playing,
  completed,
  cancelled
}

class ReservationModel {
  final int id;
  final String unlockCode;
  final ReservationStatus status;
  final String arcadeName;
  final String gameName;
  final String playerPseudo;
  final String? player2Pseudo;
  final int ticketsUsed;
  final int? positionInQueue;
  final DateTime createdAt;

  ReservationModel({
    required this.id,
    required this.unlockCode,
    required this.status,
    required this.arcadeName,
    required this.gameName,
    required this.playerPseudo,
    this.player2Pseudo,
    required this.ticketsUsed,
    this.positionInQueue,
    required this.createdAt,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      unlockCode: json['unlock_code'],
      status: ReservationStatus.values.firstWhere(
            (e) => e.name == json['status'].toLowerCase(),
      ),
      arcadeName: json['arcade_name'],
      gameName: json['game_name'],
      playerPseudo: json['player_pseudo'],
      player2Pseudo: json['player2_pseudo'],
      ticketsUsed: json['tickets_used'],
      positionInQueue: json['position_in_queue'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  bool get isWaiting => status == ReservationStatus.waiting;
  bool get isPlaying => status == ReservationStatus.playing;
  bool get canBeCancelled => status == ReservationStatus.waiting;

  String get statusText {
    switch (status) {
      case ReservationStatus.waiting:
        return 'En attente';
      case ReservationStatus.playing:
        return 'En cours';
      case ReservationStatus.completed:
        return 'Terminée';
      case ReservationStatus.cancelled:
        return 'Annulée';
    }
  }

  String get playersText {
    if (player2Pseudo != null) {
      return '$playerPseudo vs $player2Pseudo';
    }
    return playerPseudo;
  }
}