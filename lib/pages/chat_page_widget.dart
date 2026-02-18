import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/chat_message_bubble.dart';

typedef MessagesListenable = ValueListenable<List<Message>>;

class ChatPageWidget extends StatefulWidget {
  final String? initialMessage;
  final VoidCallback? onBackPressed;
  final MessagesListenable? messagesNotifier;
  final ScrollController? scrollController;

  const ChatPageWidget({
    super.key,
    this.initialMessage,
    this.onBackPressed,
    this.messagesNotifier,
    this.scrollController,
  });

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  final bool _isLoading = false;

  @override
  void didUpdateWidget(covariant ChatPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if messages updated and scrollController provided, scroll to bottom
    if (widget.messagesNotifier != null && widget.scrollController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController!.hasClients) {
          widget.scrollController!.animateTo(
            widget.scrollController!.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // If no external notifier provided, nothing else to do.
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        children: [
          Expanded(
            child: (widget.messagesNotifier == null
                ? const Center(child: CircularProgressIndicator())
                : ValueListenableBuilder<List<Message>>(
                    valueListenable: widget.messagesNotifier!,
                    builder: (context, messages, _) {
                      if (messages.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.smart_toy,
                                size: 80,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Start chatting with KixxGPT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: widget.scrollController,
                        padding: EdgeInsets.only(bottom: 16 + bottomInset),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return ChatMessageBubble(
                            message: messages[index].content,
                            isUser: messages[index].isUser,
                          );
                        },
                      );
                    },
                  )),
          ),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('KixxGPT is thinking...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
