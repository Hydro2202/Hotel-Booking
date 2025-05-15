class Message {
  final String sender;
  final String text;
  final DateTime timestamp;
  final bool isSystemMessage;

  Message({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isSystemMessage = false,
  });

  // send message
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isSystemMessage': isSystemMessage,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'],
      text: map['text'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      isSystemMessage: map['isSystemMessage'] ?? false,
    );
  }
}