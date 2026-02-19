import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onNewChat;
  final VoidCallback onSettings;
  final List<String> chatHistory;
  final int? selectedChatIndex;
  final Function(int)? onSelectChat;
  final String? userName;
  final String? userEmail;
  final String? userHandle;
  final VoidCallback? onLogout;
  final VoidCallback? onProfileTap;

  const AppDrawer({
    super.key,
    required this.onNewChat,
    required this.onSettings,
    this.chatHistory = const [],
    this.selectedChatIndex,
    this.onSelectChat,
    this.userName,
    this.userEmail,
    this.userHandle,
    this.onLogout,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 140,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onProfileTap,
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.white24,
                            child: userName != null
                                ? Text(
                                    (userName!.isNotEmpty
                                            ? userName!
                                                  .trim()
                                                  .split(' ')
                                                  .map(
                                                    (s) => s.isNotEmpty
                                                        ? s[0]
                                                        : '',
                                                  )
                                                  .join()
                                                  .toUpperCase()
                                            : 'G')
                                        .substring(0, 1),
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : const Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (userName != null)
                                Text(
                                  userName!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: onProfileTap,
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              if (userEmail != null)
                                Text(
                                  userEmail!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'KixxGPT',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onNewChat();
                },
                icon: const Icon(Icons.add),
                label: const Text('New chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
              ),
            ),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
            if (chatHistory.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Text(
                  'Recent',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              ...List.generate(chatHistory.length, (index) {
                final isSelected = index == selectedChatIndex;
                return ListTile(
                  title: Text(
                    chatHistory[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  selected: isSelected,
                  selectedTileColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  onTap: () {
                    Navigator.pop(context);
                    onSelectChat?.call(index);
                  },
                );
              }),
            ],
            const SizedBox(height: 8),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                onSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & FAQ'),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onSettings();
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[700]
                                : Colors.grey[400],
                            child: userName != null
                                ? Text(
                                    userName!
                                        .trim()
                                        .split(' ')
                                        .map((s) => s.isNotEmpty ? s[0] : '')
                                        .join()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName ?? 'Guest User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (userHandle != null)
                                  Text(
                                    userHandle!,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.8),
                                    ),
                                  )
                                else if (userEmail != null)
                                  Text(
                                    userEmail!,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.8),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.arrow_circle_up_sharp,
                            color: Colors.black,
                          ),
                          title: const Text('Upgrade plan'),
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Upgrade plan')),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.color_lens,
                            color: Colors.black,
                          ),
                          title: const Text('Personalization'),
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Personalization')),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.settings,
                            color: Colors.black,
                          ),
                          title: const Text('Settings'),
                          onTap: () {
                            Navigator.pop(context);
                            onSettings();
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.help_outline,
                            color: Colors.black,
                          ),
                          title: const Text('Help'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text(
                            'Log out',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            if (onLogout != null) {
                              onLogout!();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('👋 Logged out (mock)'),
                                ),
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
          ],
        ),
      ),
    );
  }
}
