import 'package:flutter/material.dart';
import 'package:kixxgpt/pages/login_page.dart';
import 'package:kixxgpt/providers/theme_provider.dart';
import 'package:provider/provider.dart';

// Import your files

class AppDrawer extends StatelessWidget {
  final String username;
  final List chatHistory;
  final Function createNewChat;
  final Function loadChat;
  final Function deleteChat;
  final VoidCallback? onLogout;

  const AppDrawer({
    super.key,
    required this.username,
    required this.chatHistory,
    required this.createNewChat,
    required this.loadChat,
    required this.deleteChat,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      backgroundColor: themeProvider.isDarkMode
          ? Color(0xFF1a1a1a)
          : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),

            // Logo
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.network(
                  "https://smartdigisolution.com/chatgpt/GS_Caltex_Logo.png",
                  height: 45,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Divider(
              color: themeProvider.isDarkMode
                  ? Color(0xFF333333)
                  : Color(0xFFE0E0E0),
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
                  label: Text("New Chat"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6A00),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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

            Divider(),

            // User Section
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFFF6A00),
                    child: Text(username[0].toUpperCase()),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Text(username)),

                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
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
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Color(0xFFFF6A00)),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true) {
                        if (onLogout != null) onLogout!();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
