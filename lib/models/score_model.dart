// lib/models/score_model.dart
class ScoreModel {
  final int id;
  final String player1Pseudo;
  final String? player2Pseudo;
  final String gameName;
  final String arcadeName;
  final int scoreJ1;
  final int? scoreJ2;
  final String? winnerPseudo;
  final bool isSinglePlayer;
  final DateTime createdAt;

  ScoreModel({
    required this.id,
    required this.player1Pseudo,
    this.player2Pseudo,
    required this.gameName,
    required this.arcadeName,
    required this.scoreJ1,
    this.scoreJ2,
    this.winnerPseudo,
    required this.isSinglePlayer,
    required this.createdAt,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      id: json['id'],
      player1Pseudo: json['player1_pseudo'],
      player2Pseudo: json['player2_pseudo'],
      gameName: json['game_name'],
      arcadeName: json['arcade_name'],
      scoreJ1: json['score_j1'],
      scoreJ2: json['score_j2'],
      winnerPseudo: json['winner_pseudo'],
      isSinglePlayer: json['is_single_player'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get playersText {
    if (isSinglePlayer) {
      return player1Pseudo;
    }
    return '$player1Pseudo vs ${player2Pseudo ?? 'Inconnu'}';
  }

  String get scoreText {
    if (isSinglePlayer) {
      return '$scoreJ1 points';
    }
    return '$scoreJ1 - ${scoreJ2 ?? 0}';
  }

  String get resultText {
    if (isSinglePlayer) {
      return '$scoreJ1 points';
    }

    if (winnerPseudo == null || winnerPseudo!.isEmpty) {
      return 'Score: $scoreJ1 - ${scoreJ2 ?? 0}';
    }

    if (winnerPseudo == 'Égalité') {
      return 'Égalité ($scoreJ1 - ${scoreJ2 ?? 0})';
    }

    return 'Vainqueur: $winnerPseudo ($scoreJ1 - ${scoreJ2 ?? 0})';
  }
}

class PlayerStatsModel {
  final int totalGames;
  final int soloGames;
  final int multiplayerGames;
  final int wins;
  final int losses;
  final int draws;
  final double winRate;

  PlayerStatsModel({
    required this.totalGames,
    required this.soloGames,
    required this.multiplayerGames,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.winRate,
  });

  factory PlayerStatsModel.fromJson(Map<String, dynamic> json) {
    return PlayerStatsModel(
      totalGames: json['total_games'],
      soloGames: json['solo_games'],
      multiplayerGames: json['multiplayer_games'],
      wins: json['wins'],
      losses: json['losses'],
      draws: json['draws'],
      winRate: json['win_rate'].toDouble(),
    );
  }
}