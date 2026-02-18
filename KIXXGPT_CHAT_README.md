# KixxGPT Chat Interface

A modern, ChatGPT-like AI chat interface built with Flutter. This implementation includes a full chat UI with message management, real-time responses, and a clean, intuitive design.

## Features

✨ **Core Features:**
- Real-time chat interface similar to ChatGPT
- Message history with automatic scrolling
- User-friendly input field with send button
- Loading indicator while waiting for responses
- Clear chat history functionality
- Responsive design for all screen sizes
- Dark/Light theme support
- KixxGPT branding with custom color scheme

## Project Structure

```
lib/
├── main.dart                          # Main app and ChatPage widget
├── models/
│   └── message.dart                   # Message model
├── services/
│   └── chat_service.dart              # Chat service (Mock API)
├── widgets/
│   └── chat_message_bubble.dart       # Chat message bubble widget
└── constants/
    └── app_constants.dart             # App constants
```

## Getting Started

### 1. Run the Project

```bash
flutter run
```

### 2. Using the Chat Interface

- **Send Messages:** Type a message and press Enter or tap the send button
- **View History:** All messages are displayed in the chat list
- **Clear Chat:** Tap the delete icon in the app bar to clear conversation history

## API Integration

Currently, the app uses **mock responses**. To integrate with actual OpenAI API:

### Step 1: Add HTTP Package

```bash
flutter pub add http
```

Or add to `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

### Step 2: Update ChatService

Replace the `chat_service.dart` with actual API calls:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String apiKey = 'YOUR_OPENAI_API_KEY';
  static const String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': userMessage}
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to get response');
      }
    } catch (e) {
      rethrow;
    }
  }
}
```

### Step 3: Store API Key Securely

Use the `flutter_secure_storage` package:

```bash
flutter pub add flutter_secure_storage
```

## File Descriptions

### `main.dart`
- **KixxGPTApp:** Main application widget with theme configuration
- **ChatPage:** Stateful widget for chat interface
- **_ChatPageState:** Manages chat state, messages, and user interactions

### `models/message.dart`
- **Message:** Data model for chat messages
  - `content`: Message text
  - `isUser`: Indicates if sent by user or AI
  - `timestamp`: When the message was created

### `services/chat_service.dart`
- **ChatService:** Handles API communication
  - `sendMessage()`: Sends message and gets response
  - `sendMessageStream()`: Stream-based response (for real API)
  - `clearHistory()`: Resets chat state

### `widgets/chat_message_bubble.dart`
- **ChatMessageBubble:** UI widget for individual messages
  - Styled differently for user vs. AI messages
  - Responsive sizing with max width

### `constants/app_constants.dart`
- **KixxGPTConstants:** Centralized constants for colors, messages, and durations

## Customization

### Change Primary Color

In `main.dart`, update the seed color:
```dart
seedColor: const Color(0xFF10A37F), // Change this
```

### Customize Messages

Update `chat_service.dart` or `app_constants.dart`:
```dart
static const String welcomeMessage = 'Your custom message';
```

### Modify Theme

Edit the `ThemeData` in `KixxGPTApp` build method:
```dart
theme: ThemeData(
  // Customize colors, fonts, etc.
  fontFamily: 'Your Font',
),
```

## Environment Setup

Minimum requirements:
- Flutter SDK: 3.9.2+
- Dart: Latest stable version
- Android: API 21+
- iOS: 12.0+

## Testing

Run tests with:
```bash
flutter test
```

## Troubleshooting

**Q: Messages not sending?**
- Check if `_isLoading` is preventing input
- Verify `MessageController` is initialized

**Q: Chat not scrolling?**
- Ensure `ScrollController` is attached to ListView
- Check for layout issues (nested Columns, missing Expanded)

**Q: API responses not working?**
- Replace mock responses with real API calls
- Add error handling and logging
- Test with valid API key

## Next Steps

1. ✅ Integrate with OpenAI API
2. ✅ Add conversation persistence (local storage)
3. ✅ Implement message editing/deletion
4. ✅ Add typing indicators
5. ✅ Support for file uploads
6. ✅ Add conversation management (new chat, history)

## License

This project is part of the KixxGPT Employee AI Portal.

---

For more information, visit: [www.kiixxgpt.com](https://www.kixxgpt.com)
