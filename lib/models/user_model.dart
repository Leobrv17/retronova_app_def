class UserModel {
  final int? id;
  final String? firebaseUid;
  final String email;
  final String nom;
  final String prenom;
  final String pseudo;
  final DateTime dateNaissance;
  final String numeroTelephone;
  final int? ticketsBalance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.firebaseUid,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.pseudo,
    required this.dateNaissance,
    required this.numeroTelephone,
    this.ticketsBalance,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firebaseUid: json['firebase_uid'],
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      pseudo: json['pseudo'],
      dateNaissance: DateTime.parse(json['date_naissance']),
      numeroTelephone: json['numero_telephone'],
      ticketsBalance: json['tickets_balance'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firebase_uid': firebaseUid,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'pseudo': pseudo,
      'date_naissance': dateNaissance.toIso8601String().split('T')[0],
      'numero_telephone': numeroTelephone,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'pseudo': pseudo,
      'date_naissance': dateNaissance.toIso8601String().split('T')[0],
      'numero_telephone': numeroTelephone,
    };
  }

  UserModel copyWith({
    int? id,
    String? firebaseUid,
    String? email,
    String? nom,
    String? prenom,
    String? pseudo,
    DateTime? dateNaissance,
    String? numeroTelephone,
    int? ticketsBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      email: email ?? this.email,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      pseudo: pseudo ?? this.pseudo,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      numeroTelephone: numeroTelephone ?? this.numeroTelephone,
      ticketsBalance: ticketsBalance ?? this.ticketsBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$prenom $nom';
}