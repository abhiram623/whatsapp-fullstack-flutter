import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';

class MessageModel {
  final String senderId;
  final String receiverid;
  final String messageId;
  final DateTime time;
  final MessageEnum type;
  final String text;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  MessageModel({
    required this.senderId,
    required this.receiverid,
    required this.messageId,
    required this.time,
    required this.type,
    required this.text,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  // Method to create a MessageModel from a Map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      receiverid: map['receiverid'] as String,
      messageId: map['messageId'] as String,
      time: DateTime.parse(map['time'] as String),
      type: (map['type'] as String).toEnum(),
      text: map['text'] as String,
      isSeen: map['isSeen'] as bool,
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }

  // Method to convert a MessageModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverid': receiverid,
      'messageId': messageId,
      'time': time.toIso8601String(),
      'type': type.type,
      'text': text,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }
}