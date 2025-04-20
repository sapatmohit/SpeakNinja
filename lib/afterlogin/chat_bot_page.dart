import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(SpeakNinjaApp());
}

class SpeakNinjaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeakNinja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeakNinjaScreen(),
    );
  }
}

class SpeakNinjaScreen extends StatefulWidget {
  @override
  _SpeakNinjaScreenState createState() => _SpeakNinjaScreenState();
}

class _SpeakNinjaScreenState extends State<SpeakNinjaScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FocusNode _focusNode = FocusNode();
  bool _isListening = false;

  // Replace with your actual Gemini API key.
  static String apiKey = "AIzaSyAE2z2fKDXWtHTlijdUW_61NiPHIRGfcGM";

  @override
  void initState() {
    super.initState();
    // Add default bot message
    _messages.add(ChatMessage(
      text: "How can I help you? Learner",
      isUser: false,
    ));
    // Request focus to show keyboard when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _flutterTts.stop();
    _focusNode.dispose();
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
    String prompt = "Great me with hello";
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: isUser ? Color(0xFF00598B) : Color(0xFFC7E8FF), // Different colors for user/bot
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 3,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: isUser ? Colors.white : Color(0xFF00598B), // White for user, black for bot
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
                  color: Colors.blue[400], // Color for speaker button
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 3,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () => _speak(message.text),
                  iconSize: 20,
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "SpeakNinja AI",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF00598B),
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),  // ← Change the arrow color here
      ),

      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[50]),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => _buildMessage(_messages[index]),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 28,
                      icon: Icon(
                        _isListening
                            ? CupertinoIcons.mic_fill
                            : CupertinoIcons.mic,
                        color: Color(0xFF00598B),
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
                        constraints: const BoxConstraints(maxHeight: 120),
                        child: SingleChildScrollView(
                          child: TextField(
                            focusNode: _focusNode,
                            cursorColor: Colors.black87,
                            cursorWidth: 2.0,
                            controller: _textController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                            ),
                            decoration: const InputDecoration(
                              hintText: "Type your message or speak...",
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                            minLines: 1,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 28,
                      icon: const Icon(Icons.send, color: Color(0xFF00598B)),
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