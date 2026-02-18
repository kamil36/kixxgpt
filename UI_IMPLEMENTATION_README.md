# 🚀 KixxGPT - Complete ChatGPT-Like Flutter App

A fully-featured Flutter application that replicates the ChatGPT interface with multiple screens, navigation, and professional UI design.

## 📱 Features

### ✨ **Home Screen**
- Clean, modern interface with "What can I help with?" hero text
- 4 suggestion cards:
  - 📸 Create image
  - 👁️ Analyze images
  - ✍️ Help me write
  - 📄 Summarize text
- Responsive grid layout
- Smart navigation to chat

### 💬 **Chat Screen**
- Real-time message interface
- User and AI message bubbles with different styling
- Automatic scrolling to latest messages
- Loading indicator while waiting for response
- Clear chat history functionality
- Message history preservation

### ⚙️ **Settings Screen**
- User profile section with avatar
- Multiple setting categories:
  - **My ChatGPT**: Personalization, Apps
  - **Account**: Workspace, Upgrade to Plus, Parental controls, Email
  - **General**: Appearance, Accent color, Voice, Data controls, Security, Report bug, About
- Theme customization (Light/Dark/System)
- Accent color selection
- Logout button

### 🗂️ **Sidebar Navigation**
- New chat button
- Chat history list
- Settings access
- Help & FAQ
- Selected chat highlight

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point & navigation
├── pages/
│   ├── home_page.dart                 # Home screen with suggestions
│   ├── chat_page_widget.dart          # Chat interface
│   └── settings_page.dart             # Settings & user preferences
├── models/
│   └── message.dart                   # Message model
├── services/
│   ├── chat_service.dart              # API service (mock ready for real API)
│   └── API_INTEGRATION_GUIDE.dart     # Integration instructions
├── widgets/
│   ├── chat_message_bubble.dart       # Message bubble component
│   ├── app_drawer.dart                # Sidebar navigation
│   └── suggestion_button.dart         # Reusable button component
└── constants/
    └── app_constants.dart             # App-wide constants
```

## 🎨 Design System

### Colors
- **Primary**: `#10A37F` (KixxGPT Green)
- **Light Theme**: Clean white backgrounds with subtle shadows
- **Dark Theme**: Full dark mode support with proper contrast

### Layout
- Responsive design for all screen sizes
- Material Design 3 components
- Smooth animations and transitions

### Typography
- Font: Segoe UI
- Consistent text hierarchy
- Readable sizes across all screens

## 🚀 Getting Started

### Prerequisites
- Flutter 3.9.2+
- Dart SDK
- Android/iOS/Web development setup

### Installation

```bash
cd c:\Users\Admin\Documents\Projects\kixxgpt
flutter pub get
flutter run
```

### Project Structure Navigation

1. **Start at Home** → User sees "What can I help with?"
2. **Click Suggestion** → Navigates to Chat Screen
3. **Open Drawer** → View/select chats or access Settings
4. **Settings** → Personalize app appearance and preferences

## 📋 File Descriptions

### `main.dart`
- **KixxGPTApp**: Main application with theme configuration
- **MainAppPage**: Manages navigation between Home, Chat, and Settings
- **_MainAppPageState**: Handles page routing and state management

### `pages/home_page.dart`
- **HomePage**: Landing page with suggestion cards
- **_SuggestionCard**: Individual suggestion item component

### `pages/chat_page_widget.dart`
- **ChatPageWidget**: Full chat interface
- _ChatPageWidgetState**: Manages messages and chat logic
- Built-in clear chat functionality
- Loading states and error handling

### `pages/settings_page.dart`
- **SettingsPage**: Complete settings interface
- **_SettingsOption**: Individual setting item
- Theme and appearance preferences
- User profile management

### `widgets/app_drawer.dart`
- **AppDrawer**: Sidebar navigation component
- Recent chat history
- New chat and settings shortcuts
- Help access

### `widgets/chat_message_bubble.dart`
- **ChatMessageBubble**: Styled message display
- User messages (right-aligned, primary color)
- AI messages (left-aligned, secondary color)
- Responsive bubble sizing

### `services/chat_service.dart`
- **ChatService**: API communication layer
- Mock responses for demo
- Ready for OpenAI API integration
- Stream support for real-time responses

## 🔌 API Integration

### To Connect to OpenAI API:

1. **Add HTTP Package**
```bash
flutter pub add http
```

2. **Get API Key**
   - Visit: https://platform.openai.com/api-keys
   - Create new API key

3. **Update ChatService**
   - Replace mock responses in `chat_service.dart`
   - Follow instructions in `API_INTEGRATION_GUIDE.dart`

4. **Example Integration**
```dart
Future<String> sendMessage(String userMessage) async {
  const String apiKey = 'your-api-key';
  const String model = 'gpt-3.5-turbo';

  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': model,
      'messages': [{'role': 'user', 'content': userMessage}],
      'temperature': 0.7,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  }
  throw Exception('API Error');
}
```

## 🧪 Testing

Run the widget tests:
```bash
flutter test
```

Current test verifies:
- App loads correctly
- Home screen displays properly
- All UI elements are present

## 🌐 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web
- ✅ Linux
- ✅ macOS
- ✅ Windows

## 🎯 Navigation Flow

```
┌─────────────┐
│  HomePage   │
│ (Start Here)│
└──────┬──────┘
       │ Click Suggestion
       ▼
┌─────────────┐      ┌──────────────┐
│ ChatPage    │◄────►│ AppDrawer    │
│  (Chat)     │ New  │ (Navigation) │
└──────┬──────┘ Chat └──────────────┘
       │ Back Button or Menu
       ▼
┌─────────────────────┐
│  SettingsPage       │
│ (Personalization)   │
└─────────────────────┘
```

## 💡 Tips & Tricks

### Customizing Colors
Edit `main.dart`:
```dart
seedColor: const Color(0xFF10A37F),  // Change primary color
```

### Adding More Suggestions
Edit `home_page.dart` and add to GridView:
```dart
_SuggestionCard(
  icon: Icons.your_icon,
  label: 'Your Suggestion',
  onTap: onNewChat,
),
```

### Modifying Chat History
Update `_MainAppPageState` in `main.dart`:
```dart
final List<String> _chatHistory = [
  'Your custom chat 1',
  'Your custom chat 2',
];
```

## 📦 Dependencies

- `flutter/material.dart` - UI framework
- `flutter/cupertino.dart` - iOS components (optional)

## 🐛 Troubleshooting

### Issue: App crashes on startup
- Ensure all page imports are correct
- Run `flutter pub get`
- Check for typos in class names

### Issue: Settings not saving
- Settings are currently in-memory only
- To persist, add `shared_preferences` package

### Issue: API responses not working
- Replace mock responses in `chat_service.dart`
- Verify your OpenAI API key is valid
- Check network connectivity

## 🚀 Future Enhancements

- [ ] Message persistence with local database
- [ ] User authentication
- [ ] Message editing/deletion
- [ ] Typing indicators
- [ ] File upload support
- [ ] Conversation management
- [ ] Settings persistence
- [ ] Dark/Light mode toggle
- [ ] Multiple conversation threads

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [OpenAI API Docs](https://platform.openai.com/docs)
- [Material Design 3](https://m3.material.io/)

## 📄 License

This project is part of the KixxGPT Employee AI Portal.

---

**Built with ❤️ using Flutter**

For questions or support, visit: [www.kixxgpt.com](https://www.kixxgpt.com)
