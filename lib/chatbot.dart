import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  final List<String> _hardcodedResponses = [
    "Welcome to SpeakNinja! How can I help?",
    "I'm here to assist you! What's on your mind?",
    "Let me know what you need!",
    "SpeakNinja at your service! How can I assist?"
  ];

  @override
  void dispose() {
    _textController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _sendMessage() {
    String text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _textController.clear();

    String response = _getBotResponse();
    setState(() {
      _messages.add(ChatMessage(text: response, isUser: false));
    });
    _speak(response);
  }

  String _getBotResponse() {
    return _hardcodedResponses[_messages.length % _hardcodedResponses.length];
  }

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

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  void _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Widget _buildMessage(ChatMessage message) {
    bool isUser = message.isUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFF2EC4B6) : const Color(0xFF00A676),
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
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: Color(0xFFF6F7F8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
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
                  onPressed: () {
                    _speak(message.text);
                  },
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
      backgroundColor: Color(0xFFB2D3A8),
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
                  itemBuilder: (context, index) {
                    return _buildMessage(_messages[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFB2D3A8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    // Align input to the bottom
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: Icon(
                          _isListening
                              ? CupertinoIcons.mic_fill
                              : CupertinoIcons.mic,
                          color: Color(0xFF1D7874),
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
                          constraints: BoxConstraints(
                            maxHeight:
                                150, // Maximum height threshold for expansion
                          ),
                          child: TextField(
                            cursorColor: Color(0xFF011627),
                            cursorWidth: 3.0,
                            controller: _textController,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF011627),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                            decoration: InputDecoration(
                              hintText: "Type your message or speak...",
                              hintStyle: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF011627),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            minLines: 1,
                            // Starts with 1 line
                            maxLines: 5,
                            // Expands up to 5 lines before scrolling
                            keyboardType: TextInputType.multiline,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
