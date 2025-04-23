class LevelData {
  final String targetWord;
  final int lessonNumber;
  final String hindiTranslation;
  final List<String> options;
  final String correctAnswer;
  final String audioUrl;
  final List<String> correctSentence; // New field for sentence builder
  final List<String> wordOptions; // New field for sentence builder
  final String phoneticHint; // New field for pronunciation

  LevelData({
    this.targetWord = 'Unknown',
    this.lessonNumber = 0,
    this.hindiTranslation = 'N/A',
    this.options = const [],
    this.correctAnswer = 'N/A',
    this.audioUrl = '',
    this.correctSentence = const [], // Initialize new fields
    this.wordOptions = const [],
    this.phoneticHint = '',
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      targetWord: json['target_word'] as String? ?? 'Unknown',
      lessonNumber: json['lesson_number'] as int? ?? 0,
      hindiTranslation: json['hindi_translation'] as String? ?? 'N/A',
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? [],
      correctAnswer: json['correct_answer'] as String? ?? 'N/A',
      audioUrl: json['audio_url'] as String? ?? '',
      correctSentence:
          (json['correct_sentence'] as List<dynamic>?)?.cast<String>() ?? [],
      wordOptions:
          (json['word_options'] as List<dynamic>?)?.cast<String>() ?? [],
      phoneticHint: json['phonetic_hint'] as String? ?? '',
    );
  }

  // Helper method to determine exercise type
  bool get isSentenceExercise => correctSentence.isNotEmpty;

  // Validation method
  void validate() {
    if (isSentenceExercise) {
      if (wordOptions.length < 8) {
        throw Exception('Word options must contain at least 8 items');
      }
      if (!wordOptions.toSet().containsAll(correctSentence)) {
        throw Exception('Word options missing correct sentence words');
      }
    } else {
      if (options.length != 4) {
        throw Exception('Must have exactly 4 options');
      }
      if (!options.contains(correctAnswer)) {
        throw Exception('Correct answer not in options');
      }
    }
  }
}
