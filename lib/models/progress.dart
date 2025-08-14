class Progress {
  final List<int> unlockedLevels;
  final Map<int, int> levelStars;
  final int totalStars;
  final int streak;

  Progress({
    required this.unlockedLevels,
    required this.levelStars,
    required this.totalStars,
    required this.streak,
  });

  Map<String, dynamic> toJson() {
    return {
      'unlockedLevels': unlockedLevels,
      'levelStars': levelStars,
      'totalStars': totalStars,
      'streak': streak,
    };
  }

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      unlockedLevels: List<int>.from(json['unlockedLevels']),
      levelStars: Map<int, int>.from(json['levelStars']),
      totalStars: json['totalStars'],
      streak: json['streak'],
    );
  }

  Progress copyWith({
    List<int>? unlockedLevels,
    Map<int, int>? levelStars,
    int? totalStars,
    int? streak,
  }) {
    return Progress(
      unlockedLevels: unlockedLevels ?? this.unlockedLevels,
      levelStars: levelStars ?? this.levelStars,
      totalStars: totalStars ?? this.totalStars,
      streak: streak ?? this.streak,
    );
  }
}