import 'package:flutter/material.dart';
import 'package:proyecto/controllers/level_controller.dart';
import 'package:proyecto/controllers/question_controller.dart';
import 'package:proyecto/models/level_config.dart';
import 'dart:math';

import 'package:proyecto/models/question_config.dart';
import 'package:proyecto/services/achievements_service.dart';
import 'package:proyecto/services/progress_service.dart';
import 'package:proyecto/services/sound_service.dart';


class LevelGamesScreen extends StatefulWidget {
  final int levelNumber;

  const LevelGamesScreen({Key? key, required this.levelNumber})
    : super(key: key);

  @override
  State<LevelGamesScreen> createState() => _LevelGamesScreenState();
}

class _LevelGamesScreenState extends State<LevelGamesScreen>
    with TickerProviderStateMixin {
  static const Color ocreColor = Color(0xFFCC8400);
  static const Color aguamarinaColor = Color(0xFF7FFFD4);
  static const Color flamencoColor = Color(0xFFFF6B9D);

  int currentGameIndex = 0;
  int completedGames = 0;
  int correctAnswers = 0;
  bool showResult = false;
  bool isCorrect = false;
  bool isLevelCompleted = false;
  bool isLoading = true;
  List<QuestionConfig> questions = [];
  LevelConfig? level;

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadLevelAndQuestions();
  }

  Future<void> _loadLevelAndQuestions() async {
    try {
      // Obtener el nivel
      final levels = await LevelController.getAllLevels();
      level = levels.firstWhere((l) => l.number == widget.levelNumber);
      
      // Obtener las preguntas del nivel
      questions = await QuestionController.getLevelQuestions(level!.id);
    } catch (e) {
      // Si hay un error, usar preguntas por defecto
      print('Error loading questions: $e');
      // Aquí podríamos crear preguntas por defecto si es necesario
    } finally {
      setState(() {
        isLoading = false;
      });
      _animationController.forward();
      _checkIfLevelCompleted();
    }
  }

  Future<void> _checkIfLevelCompleted() async {
    isLevelCompleted = await ProgressService.isLevelCompleted(
      widget.levelNumber,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              aguamarinaColor.withOpacity(0.3),
              flamencoColor.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildHeader(),
                    _buildProgressBar(),
                    Expanded(
                      child: showResult ? _buildResultScreen() : _buildGameScreen(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: ocreColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      level != null ? level!.title : 'Level ${widget.levelNumber}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (isLevelCompleted) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Completado',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  isLevelCompleted
                      ? 'Jugar nuevamente - Game ${currentGameIndex + 1} of ${questions.length}'
                      : 'Game ${currentGameIndex + 1} of ${questions.length}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    if (questions.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: LinearProgressIndicator(
        value: (currentGameIndex + 1) / questions.length,
        backgroundColor: Colors.white.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(ocreColor),
        minHeight: 8,
      ),
    );
  }

  Widget _buildGameScreen() {
    if (questions.isEmpty) {
      return const Center(
        child: Text(
          'No questions available for this level',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final question = questions[currentGameIndex];
    GameType gameType;

    // Convertir el tipo de pregunta del modelo a GameType
    switch (question.type.toLowerCase()) {
      case 'complete':
        gameType = GameType.complete;
        break;
      case 'translate':
        gameType = GameType.translate;
        break;
      case 'pronunciation':
        gameType = GameType.pronunciation;
        break;
      case 'vocabulary':
        gameType = GameType.vocabulary;
        break;
      case 'grammar':
        gameType = GameType.grammar;
        break;
      case 'image_match':
        gameType = GameType.vocabulary; // Usar vocabulario como fallback para image_match
        break;
      default:
        gameType = GameType.complete;
    }

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildGameTypeIcon(gameType),
                  const SizedBox(height: 20),
                  Text(
                    question.instruction,
                    style: TextStyle(
                      fontSize: 18,
                      color: ocreColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: question.options.length,
                      itemBuilder: (context, index) {
                        return _buildOptionButton(
                          question.options[index],
                          question.correctAnswer,
                        );
                      },
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

  Widget _buildGameTypeIcon(GameType type) {
    IconData icon;
    Color color;

    switch (type) {
      case GameType.complete:
        icon = Icons.edit;
        color = ocreColor;
        break;
      case GameType.translate:
        icon = Icons.translate;
        color = aguamarinaColor;
        break;
      case GameType.pronunciation:
        icon = Icons.record_voice_over;
        color = flamencoColor;
        break;
      case GameType.vocabulary:
        icon = Icons.book;
        color = ocreColor;
        break;
      case GameType.grammar:
        icon = Icons.school;
        color = aguamarinaColor;
        break;
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 40),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer) {
    return GestureDetector(
      onTap: () async {
        await SoundService.playButtonSound();
        _checkAnswer(option, correctAnswer);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.grey[50]!]),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            option,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              size: 80,
              color: isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              isCorrect ? '¡Correcto!' : '¡Incorrecto!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isCorrect
                  ? '¡Excelente trabajo!'
                  : 'No te preocupes, inténtalo de nuevo',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _nextGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? ocreColor : flamencoColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                isCorrect ? 'Continuar' : 'Intentar de nuevo',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkAnswer(String selectedAnswer, String correctAnswer) async {
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      showResult = true;
    });

    if (isCorrect) {
      correctAnswers++;
      await SoundService.playCorrectSound();
    } else {
      await SoundService.playIncorrectSound();
    }
  }

  void _nextGame() {
    if (isCorrect) {
      if (currentGameIndex < questions.length - 1) {
        setState(() {
          currentGameIndex++;
          showResult = false;
        });
        _animationController.reset();
        _animationController.forward();
      } else {
        _completeLevel();
      }
    } else {
      setState(() {
        showResult = false;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<void> _completeLevel() async {
    // Calcular estrellas basado en respuestas correctas
    int stars = 1; // Mínimo 1 estrella por completar
    if (correctAnswers >= 8)
      stars = 3;
    else if (correctAnswers >= 6)
      stars = 2;

    // Guardar progreso
    await ProgressService.setLevelStars(widget.levelNumber, stars);
    await ProgressService.updateStreak();
    await ProgressService.updateTotalStars();

    // Desbloquear siguiente nivel si no está ya desbloqueado
    if (widget.levelNumber < 10) {
      await ProgressService.unlockLevel(widget.levelNumber + 1);
    }

    // Verificar y desbloquear logros
    await AchievementsService.checkAndUnlockAchievements();

    await SoundService.playLevelCompleteSound();
    _showLevelCompleted(stars);
  }

  void _showLevelCompleted(int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, size: 80, color: ocreColor),
                const SizedBox(height: 20),
                const Text(
                  '¡Felicitaciones!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Has completado el Nivel ${widget.levelNumber}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Icon(
                      index < stars ? Icons.star : Icons.star_border,
                      color: Colors.yellow[600],
                      size: 30,
                    );
                  }),
                ),
                const SizedBox(height: 16),
                if (widget.levelNumber < 10)
                  Text(
                    '¡El Nivel ${widget.levelNumber + 1} se ha desbloqueado!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(
                      context,
                      true,
                    ); // Retorna true para indicar que se completó
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ocreColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

enum GameType { complete, translate, pronunciation, vocabulary, grammar }
