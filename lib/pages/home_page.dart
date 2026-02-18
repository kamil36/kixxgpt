import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final void Function(String) onOpenChat;
  final TextEditingController? messageController;
  final Function(String)? onSendMessage;

  const HomePage({
    super.key,
    required this.onOpenChat,
    this.messageController,
    this.onSendMessage,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = widget.messageController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.messageController == null) {
      _messageController.dispose();
    }
    super.dispose();
  }

  void _handleSendMessage() {
    final message = _messageController.text;
    if (message.isEmpty) return;

    _messageController.clear();
    widget.onSendMessage?.call(message);
    widget.onOpenChat.call('general');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.smart_toy,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'What can I help with?',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _SuggestionCard(
                          icon: Icons.image,
                          label: 'Create image',
                          onTap: () => widget.onOpenChat.call('createImage'),
                        ),
                        _SuggestionCard(
                          icon: Icons.visibility,
                          label: 'Analyze images',
                          onTap: () => widget.onOpenChat.call('analyzeImages'),
                        ),
                        _SuggestionCard(
                          icon: Icons.draw,
                          label: 'Help me write',
                          onTap: () => widget.onOpenChat.call('helpWrite'),
                        ),
                        _SuggestionCard(
                          icon: Icons.summarize,
                          label: 'Summarize text',
                          onTap: () => widget.onOpenChat.call('summarizeText'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SuggestionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
