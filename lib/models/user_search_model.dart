// lib/models/user_search_model.dart
class UserSearchResult {
  final int id;
  final String pseudo;
  final String nom;
  final String prenom;

  UserSearchResult({
    required this.id,
    required this.pseudo,
    required this.nom,
    required this.prenom,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      id: json['id'],
      pseudo: json['pseudo'],
      nom: json['nom'],
      prenom: json['prenom'],
    );
  }

  String get fullName => '$prenom $nom';
}