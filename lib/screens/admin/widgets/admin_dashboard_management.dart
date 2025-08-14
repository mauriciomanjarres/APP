import 'package:flutter/material.dart';
import '../../../services/sound_service.dart';
import '../levels_management_screen.dart';
import '../questions_management_screen.dart';

class AdminDashboardManagement extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback reloadStats;
  final BuildContext parentContext;

  const AdminDashboardManagement({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.reloadStats,
    required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        _buildManagementCard(
          'Levels Management',
          'Create, edit and manage all levels',
          Icons.layers,
          primaryColor,
          () async {
            await SoundService.playButtonSound();
            Navigator.push(
              parentContext,
              MaterialPageRoute(
                builder: (context) => const LevelsManagementScreen(),
              ),
            ).then((_) => reloadStats());
          },
          0,
        ),
        const SizedBox(height: 15),
        _buildManagementCard(
          'Questions Management',
          'Add, edit and organize questions',
          Icons.quiz,
          secondaryColor,
          () async {
            await SoundService.playButtonSound();
            Navigator.push(
              parentContext,
              MaterialPageRoute(
                builder: (context) => const QuestionsManagementScreen(),
              ),
            ).then((_) => reloadStats());
          },
          200,
        ),
      ],
    );
  }

  Widget _buildManagementCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: color.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: color,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
