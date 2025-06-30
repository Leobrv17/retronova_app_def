// lib/models/friend_model.dart
enum FriendshipStatus {
  pending,
  accepted,
  rejected
}

class FriendModel {
  final int id;
  final String pseudo;
  final String nom;
  final String prenom;

  FriendModel({
    required this.id,
    required this.pseudo,
    required this.nom,
    required this.prenom,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'],
      pseudo: json['pseudo'],
      nom: json['nom'],
      prenom: json['prenom'],
    );
  }

  String get fullName => '$prenom $nom';
}

class FriendshipModel {
  final int id;
  final FriendshipStatus status;
  final FriendModel requester;
  final FriendModel requested;

  FriendshipModel({
    required this.id,
    required this.status,
    required this.requester,
    required this.requested,
  });

  factory FriendshipModel.fromJson(Map<String, dynamic> json) {
    return FriendshipModel(
      id: json['id'],
      status: FriendshipStatus.values.firstWhere(
            (e) => e.name == json['status'].toLowerCase(),
      ),
      requester: FriendModel.fromJson(json['requester']),
      requested: FriendModel.fromJson(json['requested']),
    );
  }
}