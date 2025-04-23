import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MistralService {
  final String _defaultApiUrl = "https://api.mistral.ai/v1/chat/completions";
  final storage = const FlutterSecureStorage();
  bool _isMockMode = false;

  // Mock responses for different lesson types
  final Map<String, dynamic> _mockSentenceBuilderResponse = {
    'correct_sentence': ['The', 'cat', 'sits', 'on', 'the', 'mat'],
    'word_options': ['The', 'cat', 'sits', 'on', 'mat', 'dog', 'bed', 'sleeps']
  };

  Future<Map<String, dynamic>> fetchLessonData(String prompt) async {
    if (_isMockMode) return _mockSentenceBuilderResponse;

    try {
      final apiKey = await storage.read(key: 'mistralApiKey') ?? '';
      if (apiKey.isEmpty) throw Exception('Missing API key');

      final response = await http.post(
        Uri.parse(_defaultApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "mistral-large-latest",
          "messages": [{
            "role": "user",
            "content": "$prompt\nRespond with valid JSON containing: "
                "correct_sentence (array), word_options (array)"
          }],
          "response_format": {"type": "json_object"}
        }),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('API Error: ${e.toString()}');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('API Error ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final content = jsonDecode(data['choices'][0]['message']['content']);
    
    if (!_validateSentenceResponse(content)) {
      throw Exception('Invalid response format');
    }

    return content;
  }

  bool _validateSentenceResponse(Map<String, dynamic> data) {
    return data.containsKey('correct_sentence') &&
           data.containsKey('word_options') &&
           (data['correct_sentence'] as List).length >= 4 &&
           (data['word_options'] as List).length >= 8;
  }

  void setMockMode(bool enabled) => _isMockMode = enabled;
}