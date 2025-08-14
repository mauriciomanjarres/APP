class QuestionConfig {
  final String id;
  final String type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String instruction;
  final int points;
  final String? imageUrl; // Nuevo campo para la URL de la imagen

  QuestionConfig({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.instruction,
    required this.points,
    this.imageUrl, // Parámetro opcional para la URL de la imagen
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'instruction': instruction,
      'points': points,
      'imageUrl': imageUrl, // Agregar el campo imageUrl al JSON
    };
  }

  factory QuestionConfig.fromJson(Map<String, dynamic> json) {
    return QuestionConfig(
      id: json['id'],
      type: json['type'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      instruction: json['instruction'],
      points: json['points'],
      imageUrl: json['imageUrl'], // Agregar el campo imageUrl desde el JSON
    );
  }

  QuestionConfig copyWith({
    String? id,
    String? type,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? instruction,
    int? points,
    String? imageUrl, // Agregar el parámetro imageUrl
  }) {
    return QuestionConfig(
      id: id ?? this.id,
      type: type ?? this.type,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      instruction: instruction ?? this.instruction,
      points: points ?? this.points,
      imageUrl: imageUrl ?? this.imageUrl, // Agregar el campo imageUrl
    );
  }
}