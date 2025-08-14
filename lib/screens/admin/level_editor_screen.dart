import 'package:flutter/material.dart';
import '../../models/level_config.dart';
import '../../controllers/level_controller.dart';
import '../../services/sound_service.dart';
import 'admin_dashboard_state.dart';

class LevelEditorScreen extends StatefulWidget {
  final LevelConfig? level;

  const LevelEditorScreen({Key? key, this.level}) : super(key: key);

  @override
  State<LevelEditorScreen> createState() => _LevelEditorScreenState();
}

class _LevelEditorScreenState extends State<LevelEditorScreen> with TickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF2E3192);
  static const Color secondaryColor = Color(0xFF00BCD4);
  static const Color accentColor = Color(0xFFFF5722);
  
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _numberController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final _requiredStarsController = TextEditingController();
  final _maxStarsController = TextEditingController();
  
  String selectedDifficulty = 'Easy';
  bool isActive = true;
  bool isLoading = false;
  
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
    
    if (widget.level != null) {
      _loadLevelData();
    }
    
    _animationController.forward();
  }

  void _loadLevelData() {
    final level = widget.level!;
    _titleController.text = level.title;
    _descriptionController.text = level.description;
    _numberController.text = level.number.toString();
    _timeLimitController.text = (level.timeLimit ~/ 60).toString();
    _requiredStarsController.text = level.requiredStars.toString();
    _maxStarsController.text = level.maxStars.toString();
    selectedDifficulty = level.difficulty;
    isActive = level.isActive;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _numberController.dispose();
    _timeLimitController.dispose();
    _requiredStarsController.dispose();
    _maxStarsController.dispose();
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
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBasicInfoSection(),
                          const SizedBox(height: 30),
                          _buildConfigurationSection(),
                          const SizedBox(height: 30),
                          _buildAdvancedSection(),
                          const SizedBox(height: 40),
                          _buildSaveButton(),
                        ],
                      ),
                    ),
                  ),
                ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.level == null ? 'Create Level' : 'Edit Level',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.level == null ? 'Add a new learning level' : 'Modify level settings',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildSection(
              'Basic Information',
              Icons.info_outline,
              [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildTextField(
                        'Level Number',
                        _numberController,
                        TextInputType.number,
                        Icons.numbers,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter level number';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        'Level Title',
                        _titleController,
                        TextInputType.text,
                        Icons.title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter level title';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Description',
                  _descriptionController,
                  TextInputType.multiline,
                  Icons.description,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter level description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfigurationSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildSection(
              'Configuration',
              Icons.settings,
              [
                _buildDifficultySelector(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'Time Limit (minutes)',
                        _timeLimitController,
                        TextInputType.number,
                        Icons.timer,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter time limit';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        'Max Stars',
                        _maxStarsController,
                        TextInputType.number,
                        Icons.star,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter max stars';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdvancedSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildSection(
              'Advanced Settings',
              Icons.tune,
              [
                _buildTextField(
                  'Required Stars to Unlock',
                  _requiredStarsController,
                  TextInputType.number,
                  Icons.star_border,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter required stars';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildActiveSwitch(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    IconData icon, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Difficulty Level',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: ['Easy', 'Medium', 'Hard'].map((difficulty) {
            final isSelected = selectedDifficulty == difficulty;
            Color color;
            switch (difficulty) {
              case 'Easy':
                color = Colors.green;
                break;
              case 'Medium':
                color = Colors.orange;
                break;
              case 'Hard':
                color = accentColor;
                break;
              default:
                color = primaryColor;
            }

            return Expanded(
              child: GestureDetector(
                onTap: () async {
                  await SoundService.playButtonSound();
                  setState(() {
                    selectedDifficulty = difficulty;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    difficulty,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActiveSwitch() {
    return Row(
      children: [
        Icon(Icons.visibility, color: primaryColor),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Make this level available to students',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isActive,
          onChanged: (value) async {
            await SoundService.playButtonSound();
            setState(() {
              isActive = value;
            });
          },
          activeColor: primaryColor,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : _saveLevel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.level == null ? 'Create Level' : 'Update Level',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveLevel() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    await SoundService.playButtonSound();

    try {
      final level = LevelConfig(
        id: widget.level?.id ?? 'level_${DateTime.now().millisecondsSinceEpoch}',
        number: int.parse(_numberController.text),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        difficulty: selectedDifficulty,
        isActive: isActive,
        requiredStars: int.parse(_requiredStarsController.text),
        maxStars: int.parse(_maxStarsController.text),
        timeLimit: int.parse(_timeLimitController.text) * 60, // Convert to seconds
      );

      await LevelController.saveLevel(level);
      await SoundService.playCorrectSound();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.level == null ? 'Level created successfully!' : 'Level updated successfully!',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      AdminDashboardState().reloadStats();
      Navigator.pop(context);
    } catch (e) {
      await SoundService.playIncorrectSound();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An error occurred. Please try again.'),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
