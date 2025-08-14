import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto/screens/user/home_screen.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authService = AuthService();
  await authService.loadUserFromPrefs();
  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  const MyApp({required this.authService, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;
    return MaterialApp(
      title: 'Learn Languages App',
      home: user == null
          ? const LoginScreen()
          : user.role == 'admin'
              ? const AdminDashboardScreen()
              : const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}