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
