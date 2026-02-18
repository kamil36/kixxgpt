import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final void Function(bool isRecording) onVoicePressed;
  final VoidCallback onAttachmentPressed;
  final VoidCallback? onFocusRequested;
  final FocusNode? focusNode;
  final bool isLoading;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onVoicePressed,
    required this.onAttachmentPressed,
    this.onFocusRequested,
    this.focusNode,
    this.isLoading = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late FocusNode _focusNode;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Pill with embedded plus and text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    // small plus inside pill
                    GestureDetector(
                      onTap: widget.isLoading
                          ? null
                          : widget.onAttachmentPressed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.add, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Text field
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        enabled: !widget.isLoading,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Ask KixxGPT',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                        onTap: () {
                          widget.onFocusRequested?.call();
                        },
                        onSubmitted: (value) {
                          if (!widget.isLoading && value.isNotEmpty) {
                            widget.onSend();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // inline mic square
                    GestureDetector(
                      onTap: widget.isLoading
                          ? null
                          : () {
                              setState(() => _isRecording = !_isRecording);
                              widget.onVoicePressed(_isRecording);
                            },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _isRecording
                              ? Colors.redAccent
                              : (isDark ? Colors.grey[800] : Colors.grey[200]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: _isRecording ? Colors.white : Colors.black54,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // right circular button: send or waveform
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: hasText
                    ? const Icon(Icons.send_sharp, color: Colors.white)
                    : const Icon(Icons.graphic_eq, color: Colors.white),
                onPressed: widget.isLoading
                    ? null
                    : hasText
                    ? widget.onSend
                    : () {
                        setState(() => _isRecording = !_isRecording);
                        widget.onVoicePressed(_isRecording);
                      },
                tooltip: hasText ? 'Send message' : 'Voice input',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
