import 'package:flutter/material.dart';
import '../../controllers/stats_controller.dart';
import '../../services/admin_service.dart';
import '../../services/sound_service.dart';
import '../../services/admin_language_service.dart';
import '../../models/admin_stats.dart';
import 'levels_management_screen.dart';
import 'questions_management_screen.dart';
import 'users_management_screen.dart';
import 'admin_login_screen.dart';
import 'widgets/admin_dashboard_header.dart';
import 'widgets/admin_dashboard_stats.dart';
import 'widgets/admin_dashboard_quick_actions.dart';
import 'widgets/admin_dashboard_management.dart';
import 'admin_settings_screen.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with TickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF2E3192);
  static const Color secondaryColor = Color(0xFF00BCD4);
  static const Color accentColor = Color(0xFFFF5722);
  static const Color successColor = Color(0xFF4CAF50);

  AdminStats? stats;
  bool isLoading = true;
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  Locale _currentLocale = const Locale('es');
  bool _localeLoaded = false;

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _loadLocale();
    loadStats();
    
    // Registrar el callback de recarga de estadísticas
    AdminDashboardState().setReloadStatsCallback(loadStats);
  }

  Future<void> loadStats() async {
    final loadedStats = await StatsController.getAdminStats();
    setState(() {
      stats = loadedStats;
      isLoading = false;
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadLocale() async {
    final locale = await AdminLanguageService.getLocale();
    setState(() {
      _currentLocale = locale;
      _localeLoaded = true;
    });
  }

  Future<void> _handleLocaleChanged(Locale locale) async {
    await AdminLanguageService.setSelectedLanguage(locale.languageCode);
    setState(() {
      _currentLocale = locale;
    });
  }

  String _getDashboardTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Estadísticas';
      case 1:
        return 'Niveles';
      case 2:
        return 'Preguntas';
      case 3:
        return 'Usuarios';
      case 4:
        return 'Configuración';
      default:
        return 'Admin Dashboard';
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout from admin panel?'),
        actions: [
          TextButton(
            onPressed: () async {
              await SoundService.playButtonSound();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await SoundService.playButtonSound();
              await AdminService.adminLogout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  List<Widget> _dashboardViews(BuildContext context) => [
    // Estadísticas
    SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AdminDashboardStats(
            stats: stats,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            successColor: successColor,
          ),
          const SizedBox(height: 30),
          AdminDashboardQuickActions(
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            reloadStats: loadStats,
            parentContext: context,
          ),
        ],
      ),
    ),
    // Gestión de Niveles
    
    // Panel de Configuración profesional
    AdminSettingsScreen(
      isDarkMode: _isDarkMode,
      onThemeChanged: (value) => setState(() => _isDarkMode = value),
      onLogout: _showLogoutDialog,
      onLocaleChanged: (locale) => setState(() => _currentLocale = locale),
      currentLocale: _currentLocale,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.1),
              secondaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      AdminDashboardHeader(
                        pulseAnimation: _pulseAnimation,
                        onLogout: _showLogoutDialog,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        title: _getDashboardTitle(),
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: _dashboardViews(context),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Niveles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Preguntas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
