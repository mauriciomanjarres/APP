class UserModel {
  final String name;
  final String email;
  final String role; // 'user' o 'admin'
  final List<int> unlockedLevels;
  final Map<int, int> levelStars;
  final int streak;
  final int totalStars;
  final String photoUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    this.unlockedLevels = const [1],
    this.levelStars = const {},
    this.streak = 0,
    this.totalStars = 0,
    this.photoUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'role': role,
    'unlockedLevels': unlockedLevels,
    'levelStars': levelStars,
    'streak': streak,
    'totalStars': totalStars,
    'photoUrl': photoUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    email: json['email'],
    role: json['role'],
    unlockedLevels: List<int>.from(json['unlockedLevels'] ?? [1]),
    levelStars: Map<int, int>.from(json['levelStars'] ?? {}),
    streak: json['streak'] ?? 0,
    totalStars: json['totalStars'] ?? 0,
    photoUrl: json['photoUrl'] ?? '',
  );
}