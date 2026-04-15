import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kixxgpt/pages/login_page.dart';
import 'package:kixxgpt/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/chat.dart';
import '../providers/theme_provider.dart';

class ChatDashboard extends StatefulWidget {
  final String username;
  final VoidCallback? onLogout;

  const ChatDashboard({super.key, required this.username, this.onLogout});

  @override
  _ChatDashboardState createState() => _ChatDashboardState();
}

class _ChatDashboardState extends State<ChatDashboard> {
  final TextEditingController messageController = TextEditingController();
  List<Chat> chatHistory = [];
  Chat? currentChat;
  int chatCounter = 0;
  bool isLoading = true;
  File? selectedImage;
  String? sessionId;
  String baseUrl = "https://sai7755.com/";

  @override
  void initState() {
    super.initState();
    createNewChat();
    loadSessions();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> loadSessions() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_sessions1.php?user_id=1"),
      );

      print("RAW: ${response.body}"); // 👈 DEBUG

      // ✅ SAFETY CHECK (VERY IMPORTANT)
      if (response.body.startsWith("<")) {
        print("❌ ERROR: HTML returned instead of JSON");
        return;
      }

      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          chatHistory = data['sessions'].map<Chat>((item) {
            return Chat(
              id: item['id'].toString(),
              title: item['title'] ?? 'New Chat',
              sessionId: item['session_id'].toString(),
              messages: [],
              createdAt: DateTime.now(),
            );
          }).toList();
        });
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void createNewChat() {
    final newSessionId = const Uuid().v4(); // ✅ UNIQUE ID

    final newChat = Chat(
      id: newSessionId,
      title: 'New Chat',
      sessionId: newSessionId, // ✅ IMPORTANT
      messages: [],
      createdAt: DateTime.now(),
    );

    setState(() {
      currentChat = newChat;
      chatHistory.insert(0, newChat);
    });
  }

  Future<void> loadChat(Chat chat) async {
    setState(() {
      currentChat = chat;
      sessionId = chat.sessionId;
      isLoading = true;
    });

    Navigator.pop(context);

    try {
      final response = await http.get(
        Uri.parse("${baseUrl}history_get1.php?session_key=${chat.sessionId}"),
      );

      print("LOAD BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        List messages = [];

        for (var msg in data['messages']) {
          messages.add({'role': msg['role'], 'text': msg['message']});
        }

        setState(() {
          currentChat!.messages = messages;
          isLoading = false;
        });
      }
    } catch (e) {
      print("LOAD ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  void deleteChat(Chat chat, int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Chat'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await http.post(
        Uri.parse("${baseUrl}history_delete1.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "session_id": chat.sessionId, // ✅ use session_id
        }),
      );

      setState(() {
        chatHistory.removeWhere((c) => c.id == chat.id);
      });
    }
  }

  Future<void> saveMessage({
    required String role,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}history_save1.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": 1,
          "session_id": sessionId ?? '',
          "role": role,
          "message": message,
        }),
      );

      print("SAVE STATUS: ${response.statusCode}");
      print("SAVE BODY: ${response.body}");
    } catch (e) {
      print("Save error: $e");
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || currentChat == null) return;

    final userMessage = {
      'role': 'user',
      'text': text,
      if (selectedImage != null) 'image': selectedImage!.path,
    };

    setState(() {
      currentChat!.messages.add(userMessage);
      isLoading = true;

      // ✅ Set chat title (first message)
      if (currentChat!.title == 'New Chat' && text.isNotEmpty) {
        currentChat!.title = text.length > 30
            ? '${text.substring(0, 30)}...'
            : text;
      }
    });

    messageController.clear();

    setState(() {
      selectedImage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://sai7755.com/kixxgpt/kixx_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': 1,
          'message': text,
          'session_id': sessionId ?? '',
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          String aiResponse = responseData['reply'] ?? 'No response';

          bool isNewSession = sessionId == null;

          // ✅ Update session ID from API
          sessionId = responseData['session_id'];

          print("SESSION ID: $sessionId");

          // ✅ SAVE USER MESSAGE
          await saveMessage(role: 'user', message: text);

          // ✅ SAVE AI MESSAGE
          await saveMessage(role: 'assistant', message: aiResponse);

          // ✅ Refresh sidebar if new ch at
          if (isNewSession) {
            await loadSessions();
          }

          setState(() {
            currentChat!.messages.add({
              'role': 'assistant',
              'text': aiResponse,
            });
            isLoading = false;
          });
        } else {
          setState(() {
            currentChat!.messages.add({
              'role': 'assistant',
              'text': responseData['error'] ?? 'API error',
            });
            isLoading = false;
          });
        }
      } else {
        setState(() {
          currentChat!.messages.add({
            'role': 'assistant',
            'text': 'Server error (${response.statusCode})',
          });
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR: $e");

      setState(() {
        currentChat!.messages.add({
          'role': 'assistant',
          'text': 'Network error. Please check your connection.',
        });
        isLoading = false;
      });
    }
  }

  Widget _buildDrawer() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      backgroundColor: themeProvider.isDarkMode
          ? Color(0xFF1a1a1a)
          : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.network(
                "https://smartdigisolution.com/chatgpt/GS_Caltex_Logo.png",
                height: 45,
                scale: 1,
              ),
            ),
            SizedBox(height: 10),
            Divider(
              color: themeProvider.isDarkMode
                  ? Color(0xFF333333)
                  : Color(0xFFE0E0E0),
              height: 1,
            ),
            SizedBox(height: 5),
            // New Chat Button
            Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    createNewChat();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.add, size: 20),
                  label: Text(
                    "New Chat",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6A00),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Recent Chats Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'RECENT CHATS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.isDarkMode
                        ? Color(0xFF666666)
                        : Colors.black54,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Chat List
            Expanded(
              child: chatHistory.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: themeProvider.isDarkMode
                                ? Color(0xFF444444)
                                : Colors.grey,
                            size: 40,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No chat history yet',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Color(0xFF666666)
                                  : Colors.black54,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: chatHistory.length,
                      itemBuilder: (context, index) {
                        final chat = chatHistory[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          title: Text(
                            chat.title,
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Color(0xFFCCCCCC)
                                  : Colors.black87,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${chat.messages.length} messages',
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Color(0xFF666666)
                                  : Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                          onTap: () => loadChat(chat),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: themeProvider.isDarkMode
                                  ? Color(0xFFFF6A00)
                                  : Colors.black,
                              size: 18,
                            ),
                            onPressed: () => deleteChat(chat, index),
                          ),
                        );
                      },
                    ),
            ),

            // User Profile Section
            Divider(
              color: themeProvider.isDarkMode
                  ? Color(0xFF333333)
                  : Color(0xFFE0E0E0),
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF6A00),
                    ),
                    child: Center(
                      child: Text(
                        widget.username[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Employee",
                          style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Color(0xFF888888)
                                : Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF6A00),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: themeProvider.isDarkMode
                              ? Color(0xFF888888)
                              : Colors.black54,
                          size: 20,
                        ),
                        onPressed: () async {
                          // Show confirmation dialog
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: themeProvider.isDarkMode
                                  ? Color(0xFF1a1a1a)
                                  : Colors.white,
                              title: Text(
                                'Logout',
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to logout?',
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: themeProvider.isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(color: Color(0xFFFF6A00)),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldLogout == true) {
                            // Call logout function from parent
                            if (widget.onLogout != null) {
                              widget.onLogout!();
                            }
                            // Navigate back to login
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });

        // Show snackbar with selected image info
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image selected: ${image.name}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> captureImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo captured successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error capturing image: $e')));
    }
  }

  void showImagePickerOptions() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: themeProvider.isDarkMode
          ? Color(0xFF1a1a1a)
          : Colors.white,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.photo_library, color: Color(0xFFFF6A00)),
              title: Text(
                'Gallery',
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              onTap: () {
                onTap:
                (chat) {
                  Navigator.pop(context); // ✅ first
                  loadChat(chat); // then load
                };
                pickImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFFFF6A00)),
              title: Text(
                'Camera',
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                captureImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    FocusNode _focusNode = FocusNode();
    bool isFocused = false;

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? Color(0xFF0d0d0d)
          : Color(0xFFF5F5F5),
      drawer: AppDrawer(
        username: widget.username,
        chatHistory: chatHistory,
        createNewChat: createNewChat,
        loadChat: loadChat,
        deleteChat: deleteChat,
      ),
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode
            ? Color(0xFF1a1a1a)
            : Colors.white,
        elevation: themeProvider.isDarkMode ? 0 : 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: themeProvider.isDarkMode
                  ? Color(0xFF888888)
                  : Colors.black87,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: InkWell(
          onTap: () => createNewChat(),
          child: Text(
            'New Chat',
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: themeProvider.isDarkMode
                  ? Color(0xFF888888)
                  : Colors.black87,
              size: 24,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Content
          Expanded(
            child: currentChat == null || currentChat!.messages.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),

                          // Greeting
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1D),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  "https://smartdigisolution.com/chatgpt/GS_Caltex_Logo.png",
                                  height: 40,
                                ),
                              ),

                              // ⚡ Floating Icon
                              Positioned(
                                right: -6,
                                bottom: -6,
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6A00),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFFFF6A00,
                                        ).withValues(alpha: 0.6),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Image.asset(
                                      "assets/icon/icon1.png", // <-- your lightning icon
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          // 🔸 Orange Tag (GS CALTEX INDIA)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFF6A00,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(
                                  0xFFFF6A00,
                                ).withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color(0xFFFF6A00),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "GS CALTEX INDIA",
                                  style: TextStyle(
                                    color: Color(0xFFFF6A00),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // 🔹 KixxGPT Title
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Kixx",
                                  style: GoogleFonts.roboto(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : Color(0xFF1E1E1E),
                                  ),
                                ),
                                TextSpan(
                                  text: "GPT",
                                  style: GoogleFonts.roboto(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF6A00),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Subtitle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "By GS Caltex India Private Limited\nThis tool is created for the Sales & Marketing team of GS Caltex India",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: themeProvider.isDarkMode
                                    ? Colors.grey[400]
                                    : Color(0xFF1E1E1E),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Welcome Card
                          Container(
                            width: 320,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C2E),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                // Avatar Circle
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color(0xFFFF6A00),
                                  child: const Text(
                                    "T",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Texts
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Hello Champion, test! 👋",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Welcome to your GS Caltex AI Assistant",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),

                          // Quick Action Buttons
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),

                              crossAxisSpacing: 15,
                              children: [
                                _quickActionButton(
                                  '🛢',
                                  'Kixx Engine Oil',
                                  'Product feature & benefits',
                                  Color(0xFFFF6A00),
                                ),
                                _quickActionButton(
                                  '🚛',
                                  'Heavy Truck Products',
                                  'Best fit lubricants',
                                  null,
                                ),
                                _quickActionButton(
                                  '📝',
                                  'Write Sales Pitch',
                                  'Compelling scritps',
                                  null,
                                ),
                                _quickActionButton(
                                  '💬',
                                  'Handle Objections',
                                  'Price & Competition rebuttals',
                                  null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    itemCount:
                        currentChat!.messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end
                      if (index == currentChat!.messages.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFF6A00),
                                ),
                                child: Icon(
                                  Icons.smart_toy,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF252525),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    _buildDot(0),
                                    SizedBox(width: 4),
                                    _buildDot(1),
                                    SizedBox(width: 4),
                                    _buildDot(2),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final message = currentChat!.messages[index];
                      final isUser = message['role'] == 'user';

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isUser) ...[
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFF6A00),
                                ),
                                child: Icon(
                                  Icons.smart_toy,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Color(0xFFFF6A00)
                                      : (themeProvider.isDarkMode
                                            ? Color(0xFF252525)
                                            : Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                  border: !isUser && !themeProvider.isDarkMode
                                      ? Border.all(color: Color(0xFFE0E0E0))
                                      : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Display image if available
                                    if (message['image'] != null &&
                                        message['image']!.isNotEmpty)
                                      Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        constraints: BoxConstraints(
                                          maxWidth: 200,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Image.file(
                                          File(message['image']!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    // Display text message
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message['text']!,
                                          style: TextStyle(
                                            color: isUser
                                                ? Colors.white
                                                : (themeProvider.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black87),
                                            fontSize: 13,
                                          ),
                                        ),

                                        // Copy button only for AI messages
                                        if (!isUser)
                                          Padding(
                                            padding: EdgeInsets.only(top: 6),
                                            child: InkWell(
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text: message['text']!,
                                                  ),
                                                );

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Copied to clipboard",
                                                    ),
                                                    duration: Duration(
                                                      seconds: 1,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.copy,
                                                    size: 14,
                                                    color: Color(0xFFFF6A00),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Copy",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFFFF6A00),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Warning Text
          if (currentChat != null && currentChat!.messages.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "KixxGPT can make mistakes. Always verify important information.",
                style: TextStyle(
                  fontSize: 11,
                  color: themeProvider.isDarkMode
                      ? Color(0xFF666666)
                      : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Message Input Area
          Container(
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? Color(0xFF1a1a1a)
                  : Colors.white,
              border: Border(
                top: BorderSide(
                  color: themeProvider.isDarkMode
                      ? Color(0xFF333333)
                      : Color(0xFFE0E0E0),
                ),
              ),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                // Selected Image Preview
                if (selectedImage != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xFFFF6A00)),
                          ),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Image ready to send',
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                selectedImage!.path.split('/').last,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 18),
                          color: Color(0xFFFF6A00),
                          onPressed: () {
                            setState(() {
                              selectedImage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 13,
                        ),
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Message KixxGPT...',
                          hintStyle: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Color(0xFF666666)
                                : Colors.black54,
                          ),
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: themeProvider.isDarkMode
                                  ? Color(0xFF888888)
                                  : Colors.black54,
                            ),
                            onPressed: showImagePickerOptions,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: themeProvider.isDarkMode
                              ? Color(0xFF252525)
                              : Color(0xFFF5F5F5),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 8),

                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFF6A00),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_upward_sharp,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          sendMessage(messageController.text);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton(
    String icon,
    String title,
    String description,
    Color? color,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(10), // 🔽 reduced
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? Color(0xFF2C2C2C)
              : Color(0xFFE5E5E5),
        ),
      ),
      child: InkWell(
        onTap: () {
          sendMessage(title);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔥 important (removes extra space)
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8), // 🔽 reduced
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Text(icon, style: TextStyle(color: color, fontSize: 18)),
            ),

            SizedBox(height: 6), // 🔽 small spacing

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2),

            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeProvider.isDarkMode
                    ? Colors.grey[400]
                    : Color(0xFF1E1E1E),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    // Animate dots with offset timing
    final totalDuration = Duration(milliseconds: 1800);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: totalDuration,
      builder: (context, value, child) {
        // Calculate which dot should be visible at this time
        final adjustedValue = (value + (index * 0.25)) % 1.0;

        // Dot appears and disappears in sequence
        double opacity = 0.0;
        if (adjustedValue < 0.33) {
          opacity = adjustedValue / 0.33;
        } else if (adjustedValue < 0.66) {
          opacity = 1.0;
        } else {
          opacity = (1.0 - adjustedValue) / 0.34;
        }

        return Opacity(
          opacity: opacity,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white70,
            ),
          ),
        );
      },
    );
  }
}
