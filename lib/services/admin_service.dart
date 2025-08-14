import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/level_config.dart';
import '../models/question_config.dart';
import '../models/admin_stats.dart';
import '../services/user_service.dart';

class AdminService {
  static const String _adminCredentialsKey = 'admin_credentials';
  static const String _isAdminLoggedInKey = 'is_admin_logged_in';
  static const String _levelsDataKey = 'levels_data';
  static const String _questionsDataKey = 'questions_data';
  
  // Credenciales por defecto del admin
  static const String defaultAdminEmail = 'admin@englishapp.com';
  static const String defaultAdminPassword = 'admin123';

  // Verificar si el admin está logueado
  static Future<bool> isAdminLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAdminLoggedInKey) ?? false;
  }

  // Login de administrador
  static Future<bool> adminLogin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Por ahora usamos credenciales hardcodeadas, luego se conectará a BD
    if (email == defaultAdminEmail && password == defaultAdminPassword) {
      await prefs.setBool(_isAdminLoggedInKey, true);
      return true;
    }
    
    return false;
  }

  // Logout de administrador
  static Future<void> adminLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAdminLoggedInKey, false);
  }

  // Obtener todos los niveles
  static Future<List<LevelConfig>> getAllLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final levelsJson = prefs.getStringList(_levelsDataKey) ?? [];
    
    if (levelsJson.isEmpty) {
      // Crear niveles por defecto
      return _createDefaultLevels();
    }
    
    return levelsJson.map((json) => LevelConfig.fromJson(jsonDecode(json))).toList();
  }

  // Guardar nivel
  static Future<void> saveLevel(LevelConfig level) async {
    final prefs = await SharedPreferences.getInstance();
    final levels = await getAllLevels();
    
    final existingIndex = levels.indexWhere((l) => l.id == level.id);
    if (existingIndex != -1) {
      levels[existingIndex] = level;
    } else {
      levels.add(level);
    }
    
    final levelsJson = levels.map((l) => jsonEncode(l.toJson())).toList();
    await prefs.setStringList(_levelsDataKey, levelsJson);
  }

  // Eliminar nivel
  static Future<void> deleteLevel(String levelId) async {
    final prefs = await SharedPreferences.getInstance();
    final levels = await getAllLevels();
    levels.removeWhere((l) => l.id == levelId);
    
    final levelsJson = levels.map((l) => jsonEncode(l.toJson())).toList();
    await prefs.setStringList(_levelsDataKey, levelsJson);
  }

  // Obtener preguntas de un nivel
  static Future<List<QuestionConfig>> getLevelQuestions(String levelId) async {
    final prefs = await SharedPreferences.getInstance();
    final questionsJson = prefs.getStringList('${_questionsDataKey}_$levelId') ?? [];
    
    if (questionsJson.isEmpty) {
      return _createDefaultQuestions(levelId);
    }
    
    return questionsJson.map((json) => QuestionConfig.fromJson(jsonDecode(json))).toList();
  }

  // Guardar pregunta
  static Future<void> saveQuestion(String levelId, QuestionConfig question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = await getLevelQuestions(levelId);
    
    final existingIndex = questions.indexWhere((q) => q.id == question.id);
    if (existingIndex != -1) {
      questions[existingIndex] = question;
    } else {
      questions.add(question);
    }
    
    final questionsJson = questions.map((q) => jsonEncode(q.toJson())).toList();
    await prefs.setStringList('${_questionsDataKey}_$levelId', questionsJson);
  }

  // Eliminar pregunta
  static Future<void> deleteQuestion(String levelId, String questionId) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = await getLevelQuestions(levelId);
    questions.removeWhere((q) => q.id == questionId);
    
    final questionsJson = questions.map((q) => jsonEncode(q.toJson())).toList();
    await prefs.setStringList('${_questionsDataKey}_$levelId', questionsJson);
  }

  // Obtener estadísticas
  static Future<AdminStats> getAdminStats() async {
    final levels = await getAllLevels();
    int totalQuestions = 0;
    
    for (final level in levels) {
      final questions = await getLevelQuestions(level.id);
      totalQuestions += questions.length;
    }
    
    // Obtener usuarios para estadísticas
    final users = null;
    final activeUsers = users.where((user) => user.isActive).length;
    
    return AdminStats(
      totalLevels: levels.length,
      totalQuestions: totalQuestions,
      activeLevels: levels.where((l) => l.isActive).length,
      totalUsers: users.length,
      activeUsers: activeUsers,
    );
  }

  // Crear niveles por defecto
  static List<LevelConfig> _createDefaultLevels() {
    return List.generate(10, (index) {
      return LevelConfig(
        id: 'level_${index + 1}',
        number: index + 1,
        title: 'Level ${index + 1}',
        description: 'Basic English level ${index + 1}',
        difficulty: index < 3 ? 'Easy' : index < 7 ? 'Medium' : 'Hard',
        isActive: true,
        requiredStars: index == 0 ? 0 : 1,
        maxStars: 3,
        timeLimit: 300, // 5 minutos
      );
    });
  }

  // Crear preguntas por defecto
  static List<QuestionConfig> _createDefaultQuestions(String levelId) {
    // Retorna las preguntas por defecto que ya teníamos
    return [
      QuestionConfig(
        id: 'q1_$levelId',
        type: 'complete',
        question: 'Complete the word: H_llo',
        options: ['e', 'a', 'i', 'o'],
        correctAnswer: 'e',
        instruction: 'Complete the missing letter',
        points: 10,
      ),
      QuestionConfig(
        id: 'q2_$levelId',
        type: 'translate',
        question: "Translate: 'Casa'",
        options: ['House', 'Car', 'Tree', 'Book'],
        correctAnswer: 'House',
        instruction: 'Choose the correct translation',
        points: 10,
      ),
      // Agregar más preguntas por defecto...
    ];
  }
}
