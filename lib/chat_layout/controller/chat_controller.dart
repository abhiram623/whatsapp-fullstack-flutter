import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat_layout/chat_respository/chat_respository.dart';
import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';
import 'package:whatsapp_clone/chat_layout/messreply/provider/message_reply_provider.dart';
import 'package:whatsapp_clone/chat_layout/models/chat_contact_model.dart';
import 'package:whatsapp_clone/chat_layout/models/message_model.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';

final chatControllerProvider = Provider((ref) {
  return ChatController(chatRespository: ref.watch(chatRepositoryProvider), ref: ref);
});

class ChatController {
  final ChatRespository chatRespository;
  final ProviderRef ref;

  ChatController({required this.chatRespository, required this.ref});

  void sendTextMessages(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    final messageReply = ref.read(messagReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRespository.sendTextMessages(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            messageReply: messageReply
            
            ));
             ref.read(messagReplyProvider.notifier).update((state) => null);
  }


  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,

  ) {
    final messageReply = ref.read(messagReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRespository.sendFileMessages(context: context, file: file, receiverUserId: receiverUserId, senderUserData: value!, ref: ref, messageEnum: messageEnum,
         messageReply: messageReply!));
        ref.read(messagReplyProvider.notifier).update((state) => null);
  }

  
  Stream<List<ChatContact>> getChatContact(){
    return chatRespository.getChatContact();
  }
  Stream<List<MessageModel>> getChatStream(String receiverUserId){
    return chatRespository.getChatStream(receiverUserId);
  }
  void sendGifMessage (BuildContext context,String gifUrl,String receiverUserId){
// https://giphy.com/gifs/LINEFRIENDS-brown-line-friends-minini-DyQrKMpqkAhNHZ1iWe
// https://i.giphy.com/media/DyQrKMpqkAhNHZ1iWe/200.gif


int gifUrlPartIndex = gifUrl.lastIndexOf('-')+ 1;
String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
String newGifUrl ='https://i.giphy.com/media/$gifUrlPart/200.gif';
final messageReply = ref.read(messagReplyProvider);


    ref.read(userDataAuthProvider).whenData((value) =>
        chatRespository.sendGifMessage(
          context: context, gifUrl: newGifUrl, receiverUserId: receiverUserId, senderUserData: value!, messageReply: messageReply!));
   ref.read(messagReplyProvider.notifier).update((state) => null);
  }
  void signOut (BuildContext context){
    chatRespository.signOut(context);
  }

}
