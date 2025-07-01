// lib/models/arcade_model.dart
import 'dart:math' as math;
import 'game_model.dart';

class ArcadeModel {
  final int id;
  final String nom;
  final String description;
  final String localisation;
  final double latitude;
  final double longitude;
  final List<GameOnArcadeModel> games;

  ArcadeModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.localisation,
    required this.latitude,
    required this.longitude,
    required this.games,
  });

  factory ArcadeModel.fromJson(Map<String, dynamic> json) {
    return ArcadeModel(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      localisation: json['localisation'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      games: (json['games'] as List<dynamic>?)
          ?.map((gameJson) => GameOnArcadeModel.fromJson(gameJson))
          .toList() ?? [],
    );
  }

  // Calculer la distance par rapport à Toulouse (exemple)
  double get distanceFromToulouse {
    // Coordonnées de Toulouse
    const toulouseLat = 43.6047;
    const toulouseLng = 1.4442;

    // Formule de haversine simplifiée pour une estimation
    final lat1Rad = toulouseLat * (math.pi / 180);
    final lat2Rad = latitude * (math.pi / 180);
    final deltaLat = (latitude - toulouseLat) * (math.pi / 180);
    final deltaLng = (longitude - toulouseLng) * (math.pi / 180);

    final a = math.pow(math.sin(deltaLat / 2), 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
            math.pow(math.sin(deltaLng / 2), 2);
    final c = 2 * math.asin(math.sqrt(a));
    final earthRadius = 6371; // Rayon de la Terre en km

    return earthRadius * c;
  }

  String get formattedDistance {
    final distance = distanceFromToulouse;
    if (distance < 1) {
      return '${(distance * 1000).round()}m';
    }
    return '${distance.toStringAsFixed(1)}km';
  }
}