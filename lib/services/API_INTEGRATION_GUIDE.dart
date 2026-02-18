// Integration Guide for KixxGPT API

// Step 1: Get your API key from https://platform.openai.com/api-keys
// Step 2: Add flutter_secure_storage to pubspec.yaml:
//   flutter pub add flutter_secure_storage

// Step 3: Replace sendMessage in chat_service.dart with:

/*
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> sendMessage(String userMessage) async {
  const String apiKey = 'sk-xxx'; // Your OpenAI API Key
  const String model = 'gpt-3.5-turbo';

  try {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {
            'role': 'user',
            'content': userMessage,
          }
        ],
        'temperature': 0.7,
        'max_tokens': 2000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String aiResponse = data['choices'][0]['message']['content'];
      return aiResponse;
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
*/

// Step 4: For custom system prompts, add to messages array:

/*
'messages': [
  {
    'role': 'system',
    'content': 'You are KixxGPT, a helpful AI assistant for employee management.'
  },
  {
    'role': 'user',
    'content': userMessage,
  }
]
*/

// Step 5: To handle streaming responses:

/*
Stream<String> sendMessageStream(String userMessage) async* {
  const String apiKey = 'sk-xxx';
  
  try {
    final request = http.Request(
      'POST',
      Uri.parse('https://api.openai.com/v1/chat/completions'),
    );
    
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    });
    
    request.body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [{'role': 'user', 'content': userMessage}],
      'stream': true,
    });
    
    final streamedResponse = await request.send();
    
    await for (final line in streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      
      if (line.isEmpty || line == 'data: [DONE]') continue;
      
      if (line.startsWith('data: ')) {
        try {
          final json = jsonDecode(line.substring(6));
          final chunk = json['choices'][0]['delta']['content'] ?? '';
          if (chunk.isNotEmpty) yield chunk;
        } catch (e) {
          // Skip parsing errors
        }
      }
    }
  } catch (e) {
    yield 'Error: $e';
  }
}
*/
