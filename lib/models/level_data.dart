class LevelData {
  final String targetWord;
  final int lessonNumber;
  final String hindiTranslation;
  final List<String> options;
  final String correctAnswer;

  LevelData({
    required this.targetWord,
    required this.lessonNumber,
    required this.hindiTranslation,
    required this.options,
    required this.correctAnswer,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      targetWord: json['target_word'] as String? ?? 'Unknown', // Default value
      lessonNumber: json['lesson_number'] as int? ?? 0, // Default value
      hindiTranslation:
          json['hindi_translation'] as String? ?? 'N/A', // Default value
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [], // Default to an empty list
      correctAnswer:
          json['correct_answer'] as String? ?? 'N/A', // Default value
    );
  }
}
