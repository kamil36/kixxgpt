import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onBackPressed;
  final VoidCallback? onLogout;

  const SettingsPage({super.key, required this.onBackPressed, this.onLogout});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appearance = 'System (Default)';
  String _accentColor = 'Default';
  String _userName = 'Kamil Bombe';
  String _userEmail = 'kamilbombe855@gmail.com';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    _getInitials(_userName),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userEmail,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    _showEditProfileDialog();
                  },
                  child: const Text('Edit profile'),
                ),
              ],
            ),
          ),
          const Divider(),
          // My ChatGPT Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My ChatGPT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _SettingsOption(
                  icon: Icons.sentiment_satisfied_alt,
                  label: 'Personalization',
                  onTap: () {},
                ),
                _SettingsOption(icon: Icons.apps, label: 'Apps', onTap: () {}),
              ],
            ),
          ),
          const Divider(),
          // Account Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _SettingsOption(
                  icon: Icons.workspaces,
                  label: 'Workspace',
                  trailing: 'Personal',
                  onTap: () {},
                ),
                _SettingsOption(
                  icon: Icons.star,
                  label: 'Upgrade to Plus',
                  onTap: () {},
                ),
                _SettingsOption(
                  icon: Icons.child_care,
                  label: 'Parental controls',
                  onTap: () {},
                ),
                _SettingsOption(
                  icon: Icons.mail,
                  label: 'Email',
                  trailing: 'kamilbombe855@gmail.com',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Divider(),
          // General Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'General',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _SettingsOption(
                  icon: Icons.light_mode,
                  label: 'Appearance',
                  trailing: _appearance,
                  onTap: () {
                    _showAppearanceMenu();
                  },
                ),
                _SettingsOption(
                  icon: Icons.palette,
                  label: 'Accent color',
                  trailing: _accentColor,
                  onTap: () {
                    _showAccentColorMenu();
                  },
                ),
                _SettingsOption(
                  icon: Icons.settings,
                  label: 'General',
                  onTap: () {},
                ),
                _SettingsOption(icon: Icons.mic, label: 'Voice', onTap: () {}),
                _SettingsOption(
                  icon: Icons.security,
                  label: 'Data controls',
                  onTap: () {},
                ),
                _SettingsOption(
                  icon: Icons.lock,
                  label: 'Security',
                  onTap: () {},
                ),
                _SettingsOption(
                  icon: Icons.bug_report,
                  label: 'Report bug',
                  onTap: () {},
                ),
                _SettingsOption(icon: Icons.info, label: 'About', onTap: () {}),
              ],
            ),
          ),
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Log out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showAppearanceMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appearance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Light'),
                onTap: () {
                  setState(() => _appearance = 'Light');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                onTap: () {
                  setState(() => _appearance = 'Dark');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('System (Default)'),
                onTap: () {
                  setState(() => _appearance = 'System (Default)');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAccentColorMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Accent color',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Default'),
                onTap: () {
                  setState(() => _accentColor = 'Default');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Blue'),
                onTap: () {
                  setState(() => _accentColor = 'Blue');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Green'),
                onTap: () {
                  setState(() => _accentColor = 'Green');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getInitials(String fullName) {
    final names = fullName
        .trim()
        .split(' ')
        .where((element) => element.isNotEmpty)
        .toList();

    if (names.isEmpty) return '';
    if (names.length == 1) return names[0][0].toUpperCase();
    return (names.first[0] + names.last[0]).toUpperCase();
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userName = nameController.text.trim().isEmpty
                      ? _userName
                      : nameController.text.trim();
                  _userEmail = emailController.text.trim().isEmpty
                      ? _userEmail
                      : emailController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _SettingsOption({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      trailing: trailing != null ? Text(trailing!) : null,
      onTap: onTap,
    );
  }
}
