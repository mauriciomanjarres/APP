import '../models/question_config.dart';
import '../services/admin_service.dart';

class QuestionController {
  // Obtener preguntas de un nivel
  static Future<List<QuestionConfig>> getLevelQuestions(String levelId) async {
    return await AdminService.getLevelQuestions(levelId);
  }

  // Guardar pregunta
  static Future<void> saveQuestion(String levelId, QuestionConfig question) async {
    await AdminService.saveQuestion(levelId, question);
  }

  // Eliminar pregunta
  static Future<void> deleteQuestion(String levelId, String questionId) async {
    await AdminService.deleteQuestion(levelId, questionId);
  }
}