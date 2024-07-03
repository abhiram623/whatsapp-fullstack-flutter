import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';

class MessageReply{
  final String message;
  final bool  isMe;
  final MessageEnum messageEnum;

  MessageReply({required this.message, required this.isMe, required this.messageEnum});
}

final messagReplyProvider = StateProvider<MessageReply?>((ref) => null);