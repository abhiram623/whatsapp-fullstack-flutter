class ChatContact {
  final String name;
  final String profilePic;
  final String lastMessage;
  final DateTime timeSent;
  final String contactId;

  ChatContact({
    required this.name,
    required this.profilePic,
    required this.lastMessage,
    required this.timeSent,
    required this.contactId,
  });

  // Convert a ChatContact into a Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'lastMessage': lastMessage,
      'timeSent': timeSent.toIso8601String(),
      'contactId': contactId,
    };
  }

  // Create a ChatContact from a Map.
  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'],
      profilePic: map['profilePic'],
      lastMessage: map['lastMessage'],
      timeSent: DateTime.parse(map['timeSent']),
      contactId: map['contactId'],
    );
  }
}