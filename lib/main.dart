import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// ==================== THEME PROVIDER ====================
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF0d0d0d),
    primaryColor: Color(0xFF1DB584),
    appBarTheme: AppBarTheme(backgroundColor: Color(0xFF1a1a1a), elevation: 0),
    drawerTheme: DrawerThemeData(backgroundColor: Color(0xFF1a1a1a)),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    primaryColor: Color(0xFF1DB584),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: Colors.black87),
    ),
    cardColor: Colors.white,
    dividerColor: Color(0xFFE0E0E0),
  );
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider themeProvider = ThemeProvider();
  bool _isLoggedIn = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final username = prefs.getString('username') ?? '';

    setState(() {
      _isLoggedIn = isLoggedIn;
      _username = username;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');

    setState(() {
      _isLoggedIn = false;
      _username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            home: _isLoggedIn && _username.isNotEmpty
                ? ChatDashboard(username: _username, onLogout: _logout)
                : LoginPage(),
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
          );
        },
      ),
    );
  }
}

// ==================== LOGIN PAGE ====================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    emailController.text = 'admin@vantagegrow.com';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleSignIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', email.split('@')[0]);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDashboard(username: email.split('@')[0]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0d0d0d),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1DB584),
                    ),
                    child: Icon(Icons.smart_toy, color: Colors.white, size: 40),
                  ),
                  SizedBox(height: 30),

                  // KixxGPT Title
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Kixx',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'GPT',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1DB584),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),

                  // Subtitle
                  Text(
                    "Employee AI Assistant Portal",
                    style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                  ),
                  SizedBox(height: 50),

                  // Email Field
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Color(0xFF888888),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Email Address",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFAAAAAA),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFFFFF),
                            hintText: "Enter your email",
                            hintStyle: TextStyle(color: Color(0xFF999999)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Password Field
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: Color(0xFF888888),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFAAAAAA),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFFFFF),
                            hintText: "Enter your password",
                            hintStyle: TextStyle(color: Color(0xFF999999)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: handleSignIn,
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      label: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1DB584),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== CHAT MODEL ====================
class Chat {
  String id;
  String title;
  List<Map<String, String>> messages;
  DateTime createdAt;

  Chat({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });
}

// ==================== CHAT DASHBOARD ====================
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
  bool isLoading = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    createNewChat();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void createNewChat() {
    final newChat = Chat(
      id: 'chat_${chatCounter++}',
      title: 'New Chat',
      messages: [],
      createdAt: DateTime.now(),
    );
    setState(() {
      if (currentChat != null) {
        chatHistory.insert(0, currentChat!);
      }
      currentChat = newChat;
    });
  }

  void loadChat(Chat chat) {
    setState(() {
      currentChat = chat;
    });
    Navigator.pop(context);
  }

  void deleteChat(Chat chat, int index) async {
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return AlertDialog(
          backgroundColor: themeProvider.isDarkMode
              ? Color(0xFF1a1a1a)
              : Colors.white,
          title: Text(
            'Delete Chat',
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this chat?',
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
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
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        chatHistory.removeAt(index);
      });
    }
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
              leading: Icon(Icons.photo_library, color: Color(0xFF1DB584)),
              title: Text(
                'Gallery',
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                pickImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFF1DB584)),
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

  void sendMessage(String text) async {
    if (text.trim().isEmpty || currentChat == null) return;

    // Add user message immediately
    final userMessage = {
      'role': 'user',
      'text': text,
      if (selectedImage != null) 'image': selectedImage!.path,
    };

    setState(() {
      currentChat!.messages.add(userMessage);
      isLoading = true;

      // Update chat title if it's still "New Chat"
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
      // Make API call to the chat endpoint
      final response = await http.post(
        Uri.parse('https://smartdigisolution.com/chatgpt/api_chat_gpt.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text}),
      );

      if (response.statusCode == 200) {
        // Parse the response - API returns {success:true, reply:"message"}
        final responseData = jsonDecode(response.body);

        // Extract the reply from the API response
        String aiResponse = '';

        if (responseData['success'] == true && responseData['reply'] != null) {
          aiResponse = responseData['reply'];
        } else {
          aiResponse = 'Sorry, could not get a response. Please try again.';
        }

        setState(() {
          currentChat!.messages.add({'role': 'assistant', 'text': aiResponse});
          isLoading = false;
        });
      } else {
        // Handle API error
        setState(() {
          currentChat!.messages.add({
            'role': 'assistant',
            'text': 'Sorry, I encountered an error. Please try again later.',
          });
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle network error
      setState(() {
        currentChat!.messages.add({
          'role': 'assistant',
          'text': 'Network error. Please check your connection and try again.',
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
          children: [
            // Sidebar Header
            // Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Row(
            //     children: [
            //       Container(
            //         width: 40,
            //         height: 40,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Color(0xFF1DB584),
            //         ),
            //         child: Icon(Icons.smart_toy, color: Colors.white, size: 24),
            //       ),
            //       SizedBox(width: 12),
            //       Text(
            //         'KixxGPT',
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //           color: themeProvider.isDarkMode
            //               ? Colors.white
            //               : Colors.black87,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Image.network(
              "https://smartdigisolution.com/chatgpt/GS_Caltex_Logo.png",
              height: 70,
              scale: 1,
            ),
            Divider(
              color: themeProvider.isDarkMode
                  ? Color(0xFF333333)
                  : Color(0xFFE0E0E0),
              height: 1,
            ),

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
                    backgroundColor: Color(0xFF1DB584),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

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
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
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
                              color: Colors.red,
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
                      color: Color(0xFF1DB584),
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
                          color: Colors.red,
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
                                    style: TextStyle(color: Color(0xFF1DB584)),
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? Color(0xFF0d0d0d)
          : Color(0xFFF5F5F5),
      drawer: _buildDrawer(),
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
                          // Logo
                          // Container(
                          //   width: 100,
                          //   height: 100,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: Color(0xFF1DB584),
                          //   ),
                          //   child: Icon(
                          //     Icons.smart_toy,
                          //     color: Colors.white,
                          //     size: 60,
                          //   ),
                          // ),
                          SizedBox(height: 24),

                          // Greeting
                          Image.network(
                            "https://smartdigisolution.com/chatgpt/GS_Caltex_Logo.png",
                            height: 70,
                            scale: 1,
                          ),

                          SizedBox(height: 12),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Kixx GPT (Retail)',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  // TextSpan(
                                  //   text: widget.username,
                                  //   style: TextStyle(
                                  //     fontSize: 28,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: themeProvider.isDarkMode
                                  //         ? Colors.white
                                  //         : Colors.black87,
                                  //   ),
                                  // ),
                                  // TextSpan(
                                  //   text: ' 👋',
                                  //   style: TextStyle(
                                  //     fontSize: 28,
                                  //     color: themeProvider.isDarkMode
                                  //         ? Colors.white
                                  //         : Colors.black87,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // Subtitle
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              "By GS Caltex India Private Limited \n This tool is created for sales and marketing team of GS Caltex India",
                              style: TextStyle(
                                fontSize: 14,
                                color: themeProvider.isDarkMode
                                    ? Color.fromRGBO(108, 108, 112, 1)
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 40),

                          // Quick Action Buttons
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                _quickActionButton(
                                  Icons.mail_outline,
                                  'Write an email',
                                ),
                                _quickActionButton(
                                  Icons.description,
                                  'Explain data',
                                ),
                                _quickActionButton(
                                  Icons.image,
                                  'Analyze image',
                                ),
                                _quickActionButton(
                                  Icons.lightbulb_outline,
                                  'Give ideas',
                                ),
                                _quickActionButton(
                                  Icons.summarize,
                                  'Summarize',
                                ),
                                _quickActionButton(Icons.code, 'Code help'),
                              ],
                            ),
                          ),
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
                                  color: Color(0xFF1DB584),
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
                                  color: Color(0xFF1DB584),
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
                                      ? Color(0xFF1DB584)
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
                                                    color: Color(0xFF1DB584),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Copy",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF1DB584),
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
                            border: Border.all(color: Color(0xFF1DB584)),
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
                          color: Colors.red,
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
                        autofocus: false,
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
                        color: Color(0xFF1DB584),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white, size: 18),
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

  Widget _quickActionButton(IconData icon, String label) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? Color(0xFF333333)
              : Color(0xFFE0E0E0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            sendMessage(label);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Color(0xFF1DB584), size: 24),
              SizedBox(height: 6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  label,
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Color(0xFFCCCCCC)
                        : Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
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
