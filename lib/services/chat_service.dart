class ChatService {
  // Mock responses - Replace with actual API calls
  final List<String> mockResponses = [
    'That\'s an interesting question! Let me help you with that.',
    'I understand what you\'re asking. Here\'s what I think...',
    'Great point! Here\'s my perspective on this matter.',
    'Thanks for sharing. Based on what you said, I\'d suggest...',
    'I appreciate the context. Let me provide you with some insights.',
    'That\'s a thoughtful question. Allow me to elaborate...',
  ];

  int _responseIndex = 0;

  /// Send a message and get a response
  Future<String> sendMessage(String userMessage) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

    // Mock response
    final response = mockResponses[_responseIndex % mockResponses.length];
    _responseIndex++;

    return '$response\n\nYou said: "$userMessage"\n\n(This is a demo response. Connect to your OpenAI API for real responses.)';
  }

  /// Parse stream response (for real API integration)
  Stream<String> sendMessageStream(String userMessage) async* {
    await Future.delayed(const Duration(milliseconds: 500));

    final response = mockResponses[_responseIndex % mockResponses.length];
    _responseIndex++;

    // Simulate streaming response
    for (int i = 0; i < response.length; i++) {
      yield response[i];
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }

  /// Clear chat history
  void clearHistory() {
    _responseIndex = 0;
  }
}
