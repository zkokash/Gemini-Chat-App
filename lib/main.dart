import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//*
//const String apiKey = "";
//*
const String modelName = "gemini-2.0-flash";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gemini Chat',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E)),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  //1
  Future<String> _callGemini(String prompt) async {
    final uri = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey",
    );

    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      // لو صار خطأ من السيرفر نرمي Exception عشان نمسكه
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }

    final data = jsonDecode(response.body);

    try {
      // نحاول نطلع أول نص من أول candidate
      final candidates = data["candidates"] as List<dynamic>;
      if (candidates.isEmpty) {
        return "No candidates returned.";
      }
      final content = candidates[0]["content"];
      final parts = content["parts"] as List<dynamic>;
      final text = parts[0]["text"] as String?;
      return text ?? "Empty response.";
    } catch (_) {
      // لو كان شكل الريسبونس مختلف
      return "Unexpected response format: ${response.body}";
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _controller.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add(Message(text: messageText, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    try {
      final reply = await _callGemini(messageText);

      setState(() {
        _messages.add(Message(text: reply, isUser: false));
        _isLoading = false;
      });

      //////////Advanced////////////////////
    } catch (e, st) {
      debugPrint("Gemini error: $e");
      debugPrint("Stack: $st");
      setState(() {
        _messages.add(Message(text: "Error: $e", isUser: false));
        _isLoading = false;
      });
    }
    /////////////////////////////////
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text("Gemini Chat"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      "Say Hi to Gemini! 👋",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[_messages.length - 1 - index];
                      return _buildMessage(msg);
                    },
                  ),
          ),

          if (_isLoading)
            const LinearProgressIndicator(color: Colors.blueAccent),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF2C2C2C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////

  Widget _buildMessage(Message msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: msg.isUser ? const Color(0xFF2196F3) : const Color(0xFF333333),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: msg.isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: msg.isUser ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: SelectableText(
          msg.text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}
