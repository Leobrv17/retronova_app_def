// lib/models/game_model.dart
class GameModel {
  final int id;
  final String nom;
  final String description;
  final int minPlayers;
  final int maxPlayers;
  final int ticketCost;

  GameModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.minPlayers,
    required this.maxPlayers,
    required this.ticketCost,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      nom: json['nom'],
      description: json['description'] ?? '',
      minPlayers: json['min_players'],
      maxPlayers: json['max_players'],
      ticketCost: json['ticket_cost'],
    );
  }

  bool get supportsSinglePlayer => minPlayers <= 1;
  bool get supportsMultiplayer => maxPlayers > 1;

  String get playersDescription {
    if (minPlayers == maxPlayers) {
      return '$minPlayers joueur${minPlayers > 1 ? 's' : ''}';
    }
    return '$minPlayers-$maxPlayers joueurs';
  }
}

class GameOnArcadeModel extends GameModel {
  final int slotNumber;

  GameOnArcadeModel({
    required super.id,
    required super.nom,
    required super.description,
    required super.minPlayers,
    required super.maxPlayers,
    required super.ticketCost,
    required this.slotNumber,
  });

  factory GameOnArcadeModel.fromJson(Map<String, dynamic> json) {
    return GameOnArcadeModel(
      id: json['id'],
      nom: json['nom'],
      description: json['description'] ?? '',
      minPlayers: json['min_players'],
      maxPlayers: json['max_players'],
      ticketCost: json['ticket_cost'],
      slotNumber: json['slot_number'],
    );
  }
}

