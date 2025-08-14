import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class UserProgressCard extends StatelessWidget {
  final User user;
  final Color primaryColor;
  final Color secondaryColor;
  final Color successColor;

  const UserProgressCard({
    Key? key,
    required this.user,
    required this.primaryColor,
    required this.secondaryColor,
    required this.successColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedLevels = user;
    final totalLevels = 10; // Asumiendo 10 niveles en total
    final progress = totalLevels > 0 ? completedLevels : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          child: Icon(
            user.photoURL != null
 ? Icons.admin_panel_settings : Icons.person,
            color: primaryColor,
          ),
        ),
        title: Text(
          user.displayName ?? 'No Name',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email ?? 'No Email',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? successColor : primaryColor,
              ),
              minHeight: 6,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedLevels/$totalLevels levels',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${(progress) }% completed',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: true ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                      'Active',
                    style: TextStyle(
                      color: true ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}