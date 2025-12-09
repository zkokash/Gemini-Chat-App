/*import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = 'AIzaSyBd8WGqz3DHgwUDWwFuqC3Y3dEruxIeOic';

Future<void> main() async {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  try {
    final response = await model.generateContent(
      [Content.text('Say "Hello from Gemini" only.')],
    );
    print('RESPONSE: ${response.text}');
  } catch (e, st) {
    print('ERROR: $e');
    print(st);
  }
}
*/