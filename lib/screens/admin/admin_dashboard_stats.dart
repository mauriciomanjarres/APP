import 'package:flutter/material.dart';

import '../../models/admin_stats.dart';
import '../../services/admin_service.dart';

class AdminDashboardStats extends StatelessWidget {
  final AdminStats? stats;
  final Color primaryColor;
  final Color secondaryColor;
  final Color successColor;

  const AdminDashboardStats({
    Key? key,
    required this.stats,
    required this.primaryColor,
    required this.secondaryColor,
    required this.successColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stats == null) return const SizedBox();
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Levels',
            stats!.totalLevels.toString(),
            Icons.layers,
            primaryColor,
            0,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            'Questions',
            stats!.totalQuestions.toString(),
            Icons.quiz,
            secondaryColor,
            200,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatCard(
            'Active Levels',
            stats!.activeLevels.toString(),
            Icons.check_circle,
            successColor,
            400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
