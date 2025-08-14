import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _unlockedLevelsKey = 'unlocked_levels';
  static const String _levelStarsKey = 'level_stars';
  static const String _totalStarsKey = 'total_stars';
  static const String _streakKey = 'streak';

  // Obtener niveles desbloqueados
  static Future<List<int>> getUnlockedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedLevelsString = prefs.getStringList(_unlockedLevelsKey) ?? ['1'];
    return unlockedLevelsString.map((e) => int.parse(e)).toList();
  }

  // Desbloquear un nivel
  static Future<void> unlockLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedLevels = await getUnlockedLevels();
    
    if (!unlockedLevels.contains(level)) {
      unlockedLevels.add(level);
      final unlockedLevelsString = unlockedLevels.map((e) => e.toString()).toList();
      await prefs.setStringList(_unlockedLevelsKey, unlockedLevelsString);
    }
  }

  // Obtener estrellas de un nivel específico
  static Future<int> getLevelStars(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_levelStarsKey}_$level') ?? 0;
  }

  // Guardar estrellas de un nivel
  static Future<void> setLevelStars(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_levelStarsKey}_$level', stars);
  }

  // Obtener total de estrellas
  static Future<int> getTotalStars() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalStarsKey) ?? 0;
  }

  // Actualizar total de estrellas
  static Future<void> updateTotalStars() async {
    final prefs = await SharedPreferences.getInstance();
    int totalStars = 0;
    
    for (int i = 1; i <= 10; i++) {
      totalStars += await getLevelStars(i);
    }
    
    await prefs.setInt(_totalStarsKey, totalStars);
  }

  // Obtener racha
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  // Actualizar racha
  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final currentStreak = await getStreak();
    await prefs.setInt(_streakKey, currentStreak + 1);
  }

  // Verificar si un nivel está completado
  static Future<bool> isLevelCompleted(int level) async {
    final stars = await getLevelStars(level);
    return stars > 0;
  }
}
