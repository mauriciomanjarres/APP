import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto/services/progress_service.dart';
class AchievementsService {
  static const String _achievementsKey = 'achievements';
  
  static Future<List<Achievement>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsList = prefs.getStringList(_achievementsKey) ?? [];
    
    List<Achievement> achievements = _getAllAchievements();
    
    // Marcar logros desbloqueados
    for (String achievementId in achievementsList) {
      final index = achievements.indexWhere((a) => a.id == achievementId);
      if (index != -1) {
        achievements[index] = achievements[index].copyWith(isUnlocked: true);
      }
    }
    
    return achievements;
  }
  
  static Future<void> unlockAchievement(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsList = prefs.getStringList(_achievementsKey) ?? [];
    
    if (!achievementsList.contains(achievementId)) {
      achievementsList.add(achievementId);
      await prefs.setStringList(_achievementsKey, achievementsList);
    }
  }
  
  static Future<void> checkAndUnlockAchievements() async {
    // Verificar logros basados en progreso
    final totalStars = await ProgressService.getTotalStars();
    final streak = await ProgressService.getStreak();
    final unlockedLevels = await ProgressService.getUnlockedLevels();
    
    // Primer nivel completado
    if (totalStars > 0) {
      await unlockAchievement('first_level');
    }
    
    // 5 niveles completados
    if (unlockedLevels.length >= 6) {
      await unlockAchievement('five_levels');
    }
    
    // 10 estrellas
    if (totalStars >= 10) {
      await unlockAchievement('ten_stars');
    }
    
    // Racha de 5 días
    if (streak >= 5) {
      await unlockAchievement('five_day_streak');
    }
    
    // Perfeccionista (3 estrellas en un nivel)
    for (int i = 1; i <= 10; i++) {
      final stars = await ProgressService.getLevelStars(i);
      if (stars == 3) {
        await unlockAchievement('perfectionist');
        break;
      }
    }
  }
  
  static List<Achievement> _getAllAchievements() {
    return [
      Achievement(
        id: 'first_level',
        title: 'First Steps',
        description: 'Complete your first level',
        icon: '🎯',
        isUnlocked: false,
      ),
      Achievement(
        id: 'five_levels',
        title: 'Getting Started',
        description: 'Complete 5 levels',
        icon: '🚀',
        isUnlocked: false,
      ),
      Achievement(
        id: 'ten_stars',
        title: 'Star Collector',
        description: 'Collect 10 stars',
        icon: '⭐',
        isUnlocked: false,
      ),
      Achievement(
        id: 'five_day_streak',
        title: 'Consistent Learner',
        description: 'Maintain a 5-day streak',
        icon: '🔥',
        isUnlocked: false,
      ),
      Achievement(
        id: 'perfectionist',
        title: 'Perfectionist',
        description: 'Get 3 stars in a level',
        icon: '💎',
        isUnlocked: false,
      ),
      Achievement(
        id: 'all_levels',
        title: 'Master',
        description: 'Complete all levels',
        icon: '👑',
        isUnlocked: false,
      ),
    ];
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
  
  Achievement copyWith({bool? isUnlocked}) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
