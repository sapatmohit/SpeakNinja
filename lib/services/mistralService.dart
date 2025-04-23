class MistralService {
  Future<Map<String, dynamic>> fetchLessonData(String prompt) async {
    // Simulate fetching data from an API or database using the prompt
    await Future.delayed(const Duration(seconds: 1));
    return {
      'target_word': 'example',
      'hindi_translation': 'उदाहरण',
      'options': ['sample', 'instance', 'example', 'model'],
      'correct_answer': 'example',
      'phonetic_hint': 'ehg-ZAM-pul',
    };
  }
}
