class LevelConfig {
  final String id;
  final int number;
  final String title;
  final String description;
  final String difficulty;
  final bool isActive;
  final int requiredStars;
  final int maxStars;
  final int timeLimit;

  LevelConfig({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.isActive,
    required this.requiredStars,
    required this.maxStars,
    required this.timeLimit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'isActive': isActive,
      'requiredStars': requiredStars,
      'maxStars': maxStars,
      'timeLimit': timeLimit,
    };
  }

  factory LevelConfig.fromJson(Map<String, dynamic> json) {
    return LevelConfig(
      id: json['id'],
      number: json['number'],
      title: json['title'],
      description: json['description'],
      difficulty: json['difficulty'],
      isActive: json['isActive'],
      requiredStars: json['requiredStars'],
      maxStars: json['maxStars'],
      timeLimit: json['timeLimit'],
    );
  }

  LevelConfig copyWith({
    String? id,
    int? number,
    String? title,
    String? description,
    String? difficulty,
    bool? isActive,
    int? requiredStars,
    int? maxStars,
    int? timeLimit,
  }) {
    return LevelConfig(
      id: id ?? this.id,
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      isActive: isActive ?? this.isActive,
      requiredStars: requiredStars ?? this.requiredStars,
      maxStars: maxStars ?? this.maxStars,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }
}