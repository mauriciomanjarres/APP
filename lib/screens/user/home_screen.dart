import 'package:flutter/material.dart';
import 'package:proyecto/screens/user/achievements_screen.dart';
import 'package:proyecto/screens/user/level_games_screen.dart';
import 'package:proyecto/screens/user/settings_screen.dart';
import 'package:proyecto/services/progress_service.dart';
import 'package:proyecto/services/sound_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.setLocale}) : super(key: key);

  final Function(Locale)? setLocale;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  // Colores personalizados
  static const Color ocreColor = Color(0xFFCC8400);
  static const Color aguamarinaColor = Color(0xFF7FFFD4);
  static const Color flamencoColor = Color(0xFFFF6B9D);
  
  List<LevelData> levels = [];
  int totalStars = 0;
  int streak = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final unlockedLevels = await ProgressService.getUnlockedLevels();
    final totalStarsValue = await ProgressService.getTotalStars();
    final streakValue = await ProgressService.getStreak();
    
    List<LevelData> loadedLevels = [];
    
    for (int i = 1; i <= 10; i++) {
      final isUnlocked = unlockedLevels.contains(i);
      final stars = await ProgressService.getLevelStars(i);
      final isCompleted = await ProgressService.isLevelCompleted(i);
      
      loadedLevels.add(LevelData(i, isUnlocked, stars, isCompleted));
    }
    
    setState(() {
      levels = loadedLevels;
      totalStars = totalStarsValue;
      streak = streakValue;
      isLoading = false;
    });
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Gradiente de fondo (opcional, puedes mantenerlo si lo deseas)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  aguamarinaColor.withOpacity(0.3),
                  flamencoColor.withOpacity(0.2),
                  ocreColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildLevelMap(),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white.withOpacity(0.8), // Optional: Add a background color for the AppBar area
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Escudo de la Universidad
          Image.asset(
            'assets/images/escudo_uniguajira.png',
            height: 40, // Adjust the height to fit in the AppBar
          ),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [flamencoColor, ocreColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: flamencoColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ocreColor,
                    ),
                  ),
                  Text(
                    'Keep learning!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Estadísticas
          Row(
            children: [
              _buildStatCard(Icons.local_fire_department, '$streak', flamencoColor),
              const SizedBox(width: 10),
              _buildStatCard(Icons.star, '$totalStars', ocreColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelMap() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                return _buildLevelCard(levels[index], index);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelCard(LevelData level, int index) {
    final isUnlocked = level.isUnlocked;
    final isCompleted = level.isCompleted;
    final delay = index * 100;
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: isUnlocked ? () => _onLevelTap(level) : () => _showLockedMessage(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isUnlocked
                      ? isCompleted
                          ? [
                              Colors.green[400]!,
                              Colors.green[600]!,
                            ]
                          : [
                              _getLevelColor(index),
                              _getLevelColor(index).withOpacity(0.7),
                            ]
                      : [
                          Colors.grey[300]!,
                          Colors.grey[400]!,
                        ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: isUnlocked
                        ? isCompleted
                            ? Colors.green.withOpacity(0.4)
                            : _getLevelColor(index).withOpacity(0.4)
                        : Colors.grey.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Número del nivel
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${level.levelNumber}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? Colors.white : Colors.grey[600],
                          ),
                        ),
                        if (isUnlocked && level.stars > 0) _buildStars(level.stars),
                        if (isCompleted)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Completado',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Candado para niveles bloqueados
                  if (!isUnlocked)
                    Center(
                      child: Icon(
                        Icons.lock,
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    ),
                  // Icono de completado
                  if (isCompleted)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                    ),
                  // Efecto de brillo para niveles desbloqueados
                  if (isUnlocked && !isCompleted)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStars(int stars) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: Colors.yellow[300],
          size: 16,
        );
      }),
    );
  }

  Color _getLevelColor(int index) {
    final colors = [ocreColor, aguamarinaColor, flamencoColor];
    return colors[index % colors.length];
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomBarItem(Icons.home, 'Home', true, null),
          _buildBottomBarItem(Icons.book, 'Lessons', false, null),
          _buildBottomBarItem(Icons.emoji_events, 'Achievements', false, () async {
            await SoundService.playButtonSound();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AchievementsScreen()),
            );
          }),
          _buildBottomBarItem(Icons.settings, 'Settings', false, () async {
            await SoundService.playButtonSound();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, bool isActive, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? flamencoColor : Colors.grey[400],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? flamencoColor : Colors.grey[400],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _onLevelTap(LevelData level) async {
    await SoundService.playButtonSound();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelGamesScreen(levelNumber: level.levelNumber),
      ),
    );
    
    // Si el nivel fue completado, recargar el progreso
    if (result == true) {
      _loadProgress();
    }
  }

  void _showLockedMessage() async {
    await SoundService.playIncorrectSound();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Complete the previous level to unlock this one!'),
        backgroundColor: flamencoColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class LevelData {
  final int levelNumber;
  final bool isUnlocked;
  final int stars;
  final bool isCompleted;

  LevelData(this.levelNumber, this.isUnlocked, this.stars, this.isCompleted);
}
