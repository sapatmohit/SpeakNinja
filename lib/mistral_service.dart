import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MistralService {
  final String _defaultApiUrl =
      "https://api.mistral.ai/v1/chat/completions"; // Updated endpoint
  String get apiUrl => _apiUrlOverride ?? _defaultApiUrl;
  String? _apiUrlOverride;

  static const storage = FlutterSecureStorage();

  bool _isMockMode = false;
  final Map<String, dynamic> _mockResponse = {
    'target_word': 'नमस्ते',
    'options': ['Hello', 'Goodbye', 'Thank you', 'Yes'],
    'correct_answer': 'Hello'
  };

  Future<String?> _getApiKey() async {
    return await storage.read(key: 'mistralApiKey');
  }

  Future<void> _loadApiUrl() async {
    final storedUrl = await storage.read(key: 'mistralApiUrl');
    if (storedUrl != null) _apiUrlOverride = storedUrl;
  }

  void setApiUrl(String url) {
    _apiUrlOverride = url;
  }

  void setMockMode(bool enable) {
    _isMockMode = enable;
  }

  Future<void> saveApiKey(String apiKey) async {
    await storage.write(key: 'mistralApiKey', value: apiKey);
  }

  Future<void> saveApiUrl(String url) async {
    await storage.write(key: 'mistralApiUrl', value: url);
  }

  Future<Map<String, dynamic>> fetchLevelData(String prompt) async {
    try {
      final apiKey = await _getApiKey();
      if (apiKey == null) throw Exception('API key is not set.');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "mistral-large-latest",
          "messages": [
            {
              "role": "user",
              "content": "$prompt\n\nRespond ONLY with valid JSON containing: "
                  "target_word (English), "
                  "options (4 Hindi words in Devanagari), "
                  "correct_answer (one of the options). "
                  "Format: {target_word: string, options: string[], correct_answer: string}"
            }
          ],
          "response_format": {"type": "json_object"}
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the actual JSON content from the response structure
        final contentString = responseData['choices'][0]['message']['content'];
        final data = jsonDecode(contentString);

        // Validate response structure
        if (data['target_word'] == null ||
            data['options'] == null ||
            data['correct_answer'] == null) {
          throw Exception('API returned incomplete data: $data');
        }

        // Validate options length
        if (data['options'].length != 4) {
          throw Exception('API did not return 4 options: ${data['options']}');
        }

        return data;
      } else {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
