class MatchResult {
  final int id;
  final String matchId;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;

  MatchResult({
    required this.id,
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      id: json['id'],
      matchId: json['matchId'],
      homeTeam: json['homeTeam'],
      awayTeam: json['awayTeam'],
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
    };
  }
}
