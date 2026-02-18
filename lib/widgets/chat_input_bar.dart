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
            Row(
              children: [
                // Text Field (pill) with embedded add button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        // small plus circle inside pill
                        GestureDetector(
                          onTap: widget.isLoading ? null : widget.onAttachmentPressed,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.add, color: Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            focusNode: _focusNode,
                            enabled: !widget.isLoading,
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Typing Something',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send Button (black circle with up arrow)
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    color: Colors.white,
                    onPressed: widget.isLoading
                        ? null
                        : widget.controller.text.isEmpty
                            ? null
                            : widget.onSend,
                    tooltip: 'Send message',
                  ),
                ),
              ],
            ),
                      onSubmitted: (value) {
                        if (!widget.isLoading && value.isNotEmpty) {
                          widget.onSend();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Voice Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: Colors.grey[700],
                    ),
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            setState(() => _isRecording = !_isRecording);
                            widget.onVoicePressed(_isRecording);
                          },
                    tooltip: _isRecording
                        ? 'Stop recording'
                        : 'Start voice input',
                  ),
                ),
                const SizedBox(width: 4),
                // Send Button
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: widget.isLoading
                        ? null
                        : widget.controller.text.isEmpty
                        ? null
                        : widget.onSend,
                    tooltip: 'Send message',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
