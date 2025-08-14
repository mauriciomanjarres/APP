import '../models/level_config.dart';
import '../services/admin_service.dart';

class LevelController {
  // Obtener todos los niveles
  static Future<List<LevelConfig>> getAllLevels() async {
    return await AdminService.getAllLevels();
  }

  // Guardar nivel
  static Future<void> saveLevel(LevelConfig level) async {
    await AdminService.saveLevel(level);
  }

  // Eliminar nivel
  static Future<void> deleteLevel(String levelId) async {
    await AdminService.deleteLevel(levelId);
  }
}