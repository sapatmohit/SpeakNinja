import 'HardCodes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


// void main() {
//   runApp(SpeakNinjaApp());
// }
//
// class SpeakNinjaApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SpeakNinja',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SpeakNinjaScreen(),
//     );
//   }
// }

class SpeakNinjaScreen extends StatefulWidget {
  @override
  _SpeakNinjaScreenState createState() => _SpeakNinjaScreenState();
}

class _SpeakNinjaScreenState extends State<SpeakNinjaScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  // Replace with your actual Gemini API key.
  static String apiKey = hardcodes.gemeniekey;

  @override
  void dispose() {
    _textController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  /// Sends the user message and retrieves the AI coach's reply.
  void _sendMessage() async {
    String text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _textController.clear();

    String? response = await _getBotResponse(text);
    if (response != null) {
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });
      _speak(response);
    }
  }

  /// Calls the Gemini API to get a response.
  Future<String?> _getBotResponse(String message) async {
    String apiUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";
    String prompt = hardcodes.BasePrompt;
    String fullPrompt = "$prompt  $message";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": fullPrompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        print(fullPrompt);
        final data = jsonDecode(response.body);
        if (data["candidates"] != null && data["candidates"].isNotEmpty) {
          return data["candidates"][0]["content"]["parts"][0]["text"];
        } else {
          return "No response from the API.";
        }
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  /// Starts voice recognition.
  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech status: $status"),
      onError: (errorNotification) => print("Speech error: $errorNotification"),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
          if (result.finalResult) {
            _stopListening();
            _sendMessage();
          }
        },
      );
    } else {
      print("Speech recognition not available.");
    }
  }

  /// Stops voice recognition.
  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  /// Uses text-to-speech to speak the response.
  void _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  /// Builds a chat message bubble.
  Widget _buildMessage(ChatMessage message) {
    bool isUser = message.isUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message Bubble
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isUser ? const Color(0xFF2EC4B6) : const Color(0xFF00A676),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    color: Color(0xFFF6F7F8),
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          // Speaker Bubble (only for bot messages)
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A676),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () => _speak(message.text),
                  iconSize: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the main UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2D3A8),
      appBar: AppBar(
        title: const Text(
          "🥷 SpeakNinjaAI",
          style: TextStyle(color: Color(0xFF011627), fontFamily: 'Roboto'),
        ),
        backgroundColor: const Color(0xFF00A676),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFF041B1B)),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => _buildMessage(_messages[index]),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFB2D3A8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: Icon(
                        _isListening
                            ? CupertinoIcons.mic_fill
                            : CupertinoIcons.mic,
                        color: const Color(0xFF1D7874),
                      ),
                      onPressed: () {
                        if (!_isListening) {
                          _startListening();
                        } else {
                          _stopListening();
                        }
                      },
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: SingleChildScrollView(
                          child: TextField(
                            cursorColor: const Color(0xFF011627),
                            cursorWidth: 3.0,
                            controller: _textController,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF011627),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            decoration: const InputDecoration(
                              hintText: "Type your message or speak...",
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF011627),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            minLines: 1,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.send, color: Color(0xFF1D7874)),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Model class for a chat message.
class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}