import '../models/admin_stats.dart';
import '../services/admin_service.dart';

class StatsController {
  // Obtener estadísticas
  static Future<AdminStats> getAdminStats() async {
    return await AdminService.getAdminStats();
  }
}