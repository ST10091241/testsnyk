class LeaderboardInfo {
  final String? name;
  final String? email;
  final double? score;

  LeaderboardInfo({
    required this.name,
    required this.email,
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'score': score,
    };
  }
  factory LeaderboardInfo.fromJson(Map<String, dynamic> json) {
    return LeaderboardInfo(
      name: json['name']as String?,
      email: json['email']as String?,
      score: (json['score'] as num?)?.toDouble(),      
    );
  }
}