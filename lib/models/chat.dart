class Chat {
  String id;
  String title;
  String sessionId;
  List messages;
  DateTime createdAt;

  Chat({
    required this.id,
    required this.title,
    required this.sessionId,
    required this.messages,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'].toString(),
      title: json['title'] ?? 'New Chat',
      sessionId: json['session_id'].toString(),
      // ✅ SAFE parsing
      messages: (json['messages'] as List? ?? []).map((m) {
        return {
          "role": m['role']?.toString() ?? "",
          "text": m['message']?.toString() ?? m['text']?.toString() ?? "",
        };
      }).toList(),

      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
