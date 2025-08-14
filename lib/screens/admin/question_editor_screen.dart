import 'package:flutter/material.dart';
import '../../models/question_config.dart';
import '../../controllers/question_controller.dart';
import '../../services/sound_service.dart';

class QuestionEditorScreen extends StatefulWidget {
  final String levelId;
  final QuestionConfig? question;
  final VoidCallback? onQuestionSaved;

  const QuestionEditorScreen({
    Key? key,
    required this.levelId,
    this.question,
    this.onQuestionSaved,
  }) : super(key: key);

  @override
  State<QuestionEditorScreen> createState() => _QuestionEditorScreenState();
}

class _QuestionEditorScreenState extends State<QuestionEditorScreen> with TickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF2E3192);
  static const Color secondaryColor = Color(0xFF00BCD4);
  static const Color accentColor = Color(0xFFFF5722);
  
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _instructionController = TextEditingController();
  final _pointsController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(4, (index) => TextEditingController());
  
  String selectedType = 'complete';
  int correctAnswerIndex = 0;
  bool isLoading = false;
  String? _imageUrl; // Nuevo campo para la URL de la imagen
  
  // Mapa para almacenar contenido de pregunta por tipo
  final Map<String, String> questionContentByType = {
    'complete': 'Complete the sentence with the correct word',
    'translate': 'Translate the following sentence',
    'pronunciation': 'Select the correct pronunciation',
    'vocabulary': 'Select the correct definition',
    'grammar': 'Select the correct grammatical structure',
    'image_match': 'Select the correct image for the word',
  };
  
  // Mapa para almacenar instrucciones por tipo
  final Map<String, String> instructionByType = {
    'complete': 'Fill in the blank with the appropriate word',
    'translate': 'Choose the correct translation from the options',
    'pronunciation': 'Listen carefully and select the correct pronunciation',
    'vocabulary': 'Match the word with its correct definition',
    'grammar': 'Select the option with the correct grammar',
    'image_match': 'Match the word with the correct image',
  };
  
  // Mapa para almacenar opciones por tipo
  final Map<String, List<String>> optionsByType = {
    'complete': ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
    'translate': ['Translation 1', 'Translation 2', 'Translation 3', 'Translation 4'],
    'pronunciation': ['Pronunciation 1', 'Pronunciation 2', 'Pronunciation 3', 'Pronunciation 4'],
    'vocabulary': ['Definition 1', 'Definition 2', 'Definition 3', 'Definition 4'],
    'grammar': ['Structure 1', 'Structure 2', 'Structure 3', 'Structure 4'],
    'image_match': ['Image 1', 'Image 2', 'Image 3', 'Image 4'],
  };
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> questionTypes = [
    {'value': 'complete', 'label': 'Complete', 'icon': Icons.edit, 'color': Colors.blue},
    {'value': 'translate', 'label': 'Translate', 'icon': Icons.translate, 'color': Colors.green},
    {'value': 'pronunciation', 'label': 'Pronunciation', 'icon': Icons.record_voice_over, 'color': Colors.red},
    {'value': 'vocabulary', 'label': 'Vocabulary', 'icon': Icons.book, 'color': Colors.purple},
    {'value': 'grammar', 'label': 'Grammar', 'icon': Icons.school, 'color': Colors.orange},
    {'value': 'image_match', 'label': 'Image Match', 'icon': Icons.image_search, 'color': Colors.teal},
  ];

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
    
    if (widget.question != null) {
      _loadQuestionData();
    } else {
      _pointsController.text = '10'; // Default points
    }
    
    _animationController.forward();
  }

  void _loadQuestionData() {
    final question = widget.question!;
    _questionController.text = question.question;
    _instructionController.text = question.instruction;
    _pointsController.text = question.points.toString();
    selectedType = question.type;
    _imageUrl = question.imageUrl; // Cargar la URL de la imagen
    
    // Cargar opciones por tipo
    _loadDefaultContentForType(selectedType);
    
    for (int i = 0; i < question.options.length && i < 4; i++) {
      _optionControllers[i].text = question.options[i];
      if (question.options[i] == question.correctAnswer) {
        correctAnswerIndex = i;
      }
    }
  }
  
  void _loadDefaultContentForType(String type) {
    // Solo cargar contenido por defecto si es una pregunta nueva (sin datos)
    if (_questionController.text.isEmpty) {
      // Cargar contenido de pregunta por tipo
      if (questionContentByType.containsKey(type)) {
        _questionController.text = questionContentByType[type]!;
      }
    }
    
    // Solo cargar instrucción por defecto si es una pregunta nueva (sin datos)
    if (_instructionController.text.isEmpty) {
      // Cargar instrucción por tipo
      if (instructionByType.containsKey(type)) {
        _instructionController.text = instructionByType[type]!;
      }
    }
    
    // Solo cargar opciones por defecto si es una pregunta nueva (sin datos)
    if (_optionControllers.every((controller) => controller.text.isEmpty)) {
      // Cargar opciones por tipo
      if (optionsByType.containsKey(type)) {
        final options = optionsByType[type]!;
        for (int i = 0; i < options.length && i < 4; i++) {
          _optionControllers[i].text = options[i];
        }
        // Establecer la primera opción como correcta por defecto
        correctAnswerIndex = 0;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _questionController.dispose();
    _instructionController.dispose();
    _pointsController.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
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
                          _buildQuestionTypeSection(),
                          const SizedBox(height: 30),
                          _buildQuestionContentSection(),
                          const SizedBox(height: 30),
                          _buildOptionsSection(),
                          const SizedBox(height: 30),
                          _buildSettingsSection(),
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
                  widget.question == null ? 'Create Question' : 'Edit Question',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.question == null ? 'Add a new question' : 'Modify question content',
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

  Widget _buildQuestionTypeSection() {
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
              'Question Type',
              Icons.category,
              [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: questionTypes.length,
                  itemBuilder: (context, index) {
                    final type = questionTypes[index];
                    final isSelected = selectedType == type['value'];
                    
                    return GestureDetector(
                      onTap: () async {
                        await SoundService.playButtonSound();
                        setState(() {
                          selectedType = type['value'];
                          // Cargar contenido por defecto para el nuevo tipo
                          // Si es una pregunta nueva o si los campos están vacíos, cargar contenido por defecto
                          if (widget.question == null ||
                              _questionController.text.isEmpty ||
                              _instructionController.text.isEmpty ||
                              _optionControllers.every((controller) => controller.text.isEmpty)) {
                            _loadDefaultContentForType(selectedType);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? type['color'] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? type['color'] : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              type['icon'],
                              color: isSelected ? Colors.white : Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              type['label'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionContentSection() {
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
              'Question Content',
              Icons.help_outline,
              [
                _buildTextField(
                  'Question',
                  _questionController,
                  TextInputType.multiline,
                  Icons.quiz,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Instruction',
                  _instructionController,
                  TextInputType.text,
                  Icons.info,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the instruction';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Mostrar el botón de selección de imagen solo para el tipo "image_match"
                if (selectedType == 'image_match') ...[
                  ElevatedButton.icon(
                    onPressed: _selectImage,
                    icon: const Icon(Icons.image),
                    label: Text(_imageUrl == null ? 'Seleccionar Imagen' : 'Cambiar Imagen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (_imageUrl != null) ...[
                    const SizedBox(height: 16),
                    // Mostrar vista previa de la imagen seleccionada
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionsSection() {
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
              'Answer Options',
              Icons.list,
              [
                const Text(
                  'Tap the correct answer to mark it',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await SoundService.playButtonSound();
                            setState(() {
                              correctAnswerIndex = index;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: correctAnswerIndex == index ? Colors.green : Colors.grey[200],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: correctAnswerIndex == index ? Colors.green : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              correctAnswerIndex == index ? Icons.check : Icons.radio_button_unchecked,
                              color: correctAnswerIndex == index ? Colors.white : Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _optionControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Option ${index + 1}',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: correctAnswerIndex == index 
                                  ? Colors.green.withOpacity(0.1) 
                                  : Colors.grey[50],
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: correctAnswerIndex == index ? Colors.green : primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter option ${index + 1}';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildSection(
              'Settings',
              Icons.tune,
              [
                _buildTextField(
                  'Points',
                  _pointsController,
                  TextInputType.number,
                  Icons.star,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter points';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
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

  Widget _buildSaveButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
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
              onPressed: isLoading ? null : _saveQuestion,
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
                      widget.question == null ? 'Create Question' : 'Update Question',
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

  Future<void> _saveQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    await SoundService.playButtonSound();

    try {
      final options = _optionControllers.map((controller) => controller.text.trim()).toList();
      
      final question = QuestionConfig(
        id: widget.question?.id ?? 'q_${DateTime.now().millisecondsSinceEpoch}',
        type: selectedType,
        question: _questionController.text.trim(),
        options: options,
        correctAnswer: options[correctAnswerIndex],
        instruction: _instructionController.text.trim(),
        points: int.parse(_pointsController.text),
        imageUrl: _imageUrl, // Agregar la URL de la imagen
      );

      await QuestionController.saveQuestion(widget.levelId, question);
      await SoundService.playCorrectSound();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.question == null ? 'Question created successfully!' : 'Question updated successfully!',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      if (widget.onQuestionSaved != null) {
        widget.onQuestionSaved!();
      }
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
  
  // Método para seleccionar una imagen (simulación)
  Future<void> _selectImage() async {
    // En una implementación real, aquí se usaría image_picker para seleccionar una imagen
    // Por ahora, vamos a simular la selección de una URL de imagen
    await SoundService.playButtonSound();
    
    // Simular la selección de una imagen con un diálogo
    final url = await _showImageUrlDialog();
    if (url != null && url.isNotEmpty) {
      setState(() {
        _imageUrl = url;
      });
    }
  }
  
  // Método para mostrar un diálogo para ingresar la URL de la imagen
  Future<String?> _showImageUrlDialog() async {
    final controller = TextEditingController();
    
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ingrese la URL de la imagen'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'https://example.com/image.jpg',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
