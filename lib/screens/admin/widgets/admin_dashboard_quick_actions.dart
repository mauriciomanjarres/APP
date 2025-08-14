import 'package:flutter/material.dart';
import '../../../services/sound_service.dart';
import '../levels_management_screen.dart';
import '../questions_management_screen.dart';

class AdminDashboardQuickActions extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback reloadStats;
  final BuildContext parentContext;

  const AdminDashboardQuickActions({
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
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Add Level',
                Icons.add_circle,
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
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildActionButton(
                'Add Question',
                Icons.help_outline,
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
