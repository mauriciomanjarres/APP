import 'package:flutter/material.dart';
import '../../models/level_config.dart';
import '../../models/question_config.dart';
import '../../controllers/question_controller.dart';
import '../../controllers/level_controller.dart';
import '../../services/sound_service.dart';
import 'question_editor_screen.dart';
import 'admin_dashboard_state.dart';

class QuestionsManagementScreen extends StatefulWidget {
  const QuestionsManagementScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsManagementScreen> createState() => _QuestionsManagementScreenState();
}

class _QuestionsManagementScreenState extends State<QuestionsManagementScreen> with TickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF2E3192);
  static const Color secondaryColor = Color(0xFF00BCD4);
  static const Color accentColor = Color(0xFFFF5722);
  
  List<LevelConfig> levels = [];
  String? selectedLevelId;
  List<QuestionConfig> questions = [];
  bool isLoading = true;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    final loadedLevels = await LevelController.getAllLevels();
    setState(() {
      levels = loadedLevels;
      if (levels.isNotEmpty) {
        selectedLevelId = levels.first.id;
        _loadQuestions();
      } else {
        isLoading = false;
      }
    });
    _animationController.forward();
  }

  Future<void> _loadQuestions() async {
    if (selectedLevelId == null) return;
    
    final loadedQuestions = await QuestionController.getLevelQuestions(selectedLevelId!);
    setState(() {
      questions = loadedQuestions;
      isLoading = false;
    });
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
              primaryColor.withOpacity(0.1),
              secondaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              if (levels.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No levels available.\nCreate levels first.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _buildLevelSelector(),
                        Expanded(child: _buildQuestionsList()),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: selectedLevelId != null ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              await SoundService.playButtonSound();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Questions Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Create and manage questions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${questions.length} Questions',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLevelId,
          isExpanded: true,
          hint: const Text('Select a level'),
          icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
          items: levels.map((level) {
            return DropdownMenuItem<String>(
              value: level.id,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${level.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      level.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) async {
            await SoundService.playButtonSound();
            setState(() {
              selectedLevelId = value;
              isLoading = true;
            });
            _loadQuestions();
          },
        ),
      ),
    );
  }

  Widget _buildQuestionsList() {
    if (questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No questions created yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first question',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(50 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: _buildQuestionCard(questions[index], index),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuestionCard(QuestionConfig question, int index) {
    Color typeColor;
    IconData typeIcon;
    
    switch (question.type.toLowerCase()) {
      case 'complete':
        typeColor = Colors.blue;
        typeIcon = Icons.edit;
        break;
      case 'translate':
        typeColor = Colors.green;
        typeIcon = Icons.translate;
        break;
      case 'pronunciation':
        typeColor = accentColor;
        typeIcon = Icons.record_voice_over;
        break;
      case 'vocabulary':
        typeColor = Colors.purple;
        typeIcon = Icons.book;
        break;
      case 'grammar':
        typeColor = Colors.orange;
        typeIcon = Icons.school;
        break;
      default:
        typeColor = primaryColor;
        typeIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                typeColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: typeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(typeIcon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.type.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: typeColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question.instruction,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleQuestionMenuAction(value, question),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy, size: 20),
                              SizedBox(width: 8),
                              Text('Duplicate'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.more_vert, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: question.options.map((option) {
                          final isCorrect = option == question.correctAnswer;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isCorrect ? Colors.green : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isCorrect)
                                  const Icon(Icons.check, color: Colors.green, size: 16),
                                if (isCorrect) const SizedBox(width: 4),
                                Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCorrect ? Colors.green : Colors.black87,
                                    fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${question.points} pts',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: FloatingActionButton.extended(
            onPressed: () async {
              await SoundService.playButtonSound();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionEditorScreen(
                    levelId: selectedLevelId!,
                    onQuestionSaved: () {
                      // Recargar estadísticas del dashboard
                      AdminDashboardState().reloadStats();
                    },
                  ),
                ),
              ).then((_) => _loadQuestions());
            },
            backgroundColor: primaryColor,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'New Question',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleQuestionMenuAction(String action, QuestionConfig question) async {
    await SoundService.playButtonSound();
    
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionEditorScreen(
              levelId: selectedLevelId!,
              question: question,
              onQuestionSaved: () {
                // Recargar estadísticas del dashboard
                AdminDashboardState().reloadStats();
              },
            ),
          ),
        ).then((_) => _loadQuestions());
        break;
      case 'duplicate':
        final newQuestion = question.copyWith(
          id: 'q_${DateTime.now().millisecondsSinceEpoch}',
          question: '${question.question} (Copy)',
        );
        await QuestionController.saveQuestion(selectedLevelId!, newQuestion);
        _loadQuestions();
        AdminDashboardState().reloadStats();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question duplicated successfully')),
        );
        break;
      case 'delete':
        _showDeleteQuestionDialog(question);
        break;
    }
  }

  void _showDeleteQuestionDialog(QuestionConfig question) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
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
              await QuestionController.deleteQuestion(selectedLevelId!, question.id);
              Navigator.pop(context);
              _loadQuestions();
              AdminDashboardState().reloadStats();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Question deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
