class Message {
  final String text;
  final bool isUser;
  final String? translatedText;
  final DateTime timestamp;
  final String sourceLanguage;
  final String targetLanguage;

  Message({
    required this.text,
    required this.isUser,
    this.translatedText,
    required this.timestamp,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      isUser: json['isUser'],
      translatedText: json['translatedText'] ?? json['translation'],
      timestamp: DateTime.parse(json['timestamp']),
      sourceLanguage: json['sourceLanguage'],
      targetLanguage: json['targetLanguage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'translatedText': translatedText,
      'timestamp': timestamp.toIso8601String(),
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
    };
  }
}