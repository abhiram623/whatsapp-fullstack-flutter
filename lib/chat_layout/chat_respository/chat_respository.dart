import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';
import 'package:whatsapp_clone/chat_layout/messreply/provider/message_reply_provider.dart';
import 'package:whatsapp_clone/chat_layout/models/chat_contact_model.dart';
import 'package:whatsapp_clone/chat_layout/models/message_model.dart';
import 'package:whatsapp_clone/landing%20scrn/landing_screen.dart';

import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/respository/common_firebasestorage.dart';
import 'package:whatsapp_clone/utils/snack_bar.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRespository(
      firebaseFirestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance);
});

class ChatRespository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;

  ChatRespository({required this.firebaseFirestore, required this.auth});

  void signOut(BuildContext context) async {
    try {
      await auth.signOut().then((value) => MaterialPageRoute(
            builder: (context) => LandingScreen(),
          ));
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Stream<List<MessageModel>> getChatStream(String receiverUserId) {
    return firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var doc in event.docs) {
        var mess = MessageModel.fromMap(doc.data());
        messages.add(mess);
      }
      return messages;
    });
  }

  Stream<List<ChatContact>> getChatContact() {
    return firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];

      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firebaseFirestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            lastMessage: chatContact.lastMessage,
            timeSent: chatContact.timeSent,
            contactId: chatContact.contactId));
      }
      return contacts;
    });
  }

  void _saveDataToMessageSubCollection({
    required String messageId,
    required String receiverUserId,
    required DateTime timeSent,
    required String text,
    required String senderUserName,
    required String receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
  }) async {
    var message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverid: receiverUserId,
      messageId: messageId,
      time: timeSent,
      type: messageType,
      text: text,
      isSeen: false,
      repliedMessage: messageReply == null ? "" : messageReply.message,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      repliedTo: messageReply == null
          ? ""
          : messageReply.isMe
              ? senderUserName
              : receiverUserName,
    );

    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firebaseFirestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void _saveDatatoContactSubCollection(
      {required UserModel senderUserData,
      required UserModel receiverUserData,
      required DateTime timeSent,
      required String lastMessage,
      required String receiverUserId}) async {
    var receiverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        lastMessage: lastMessage,
        timeSent: timeSent,
        contactId: senderUserData.uid);

    await firebaseFirestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        lastMessage: lastMessage,
        timeSent: timeSent,
        contactId: receiverUserData.uid);

    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void sendTextMessages({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();
      UserModel receiverUserData;

      var userData =
          await firebaseFirestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userData.data()!);

      _saveDatatoContactSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          timeSent: timeSent,
          lastMessage: text,
          receiverUserId: receiverUserId);

      _saveDataToMessageSubCollection(
        messageId: messageId,
        receiverUserId: receiverUserId,
        timeSent: timeSent,
        text: text,
        senderUserName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        messageType: MessageEnum.text,
        messageReply: messageReply,
      );
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void sendFileMessages({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply messageReply
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();
      UserModel receiverUserData;
      var userData =
          await firebaseFirestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userData.data()!);

      String imageUrl = await ref
          .read(commonFirebseStorageRespositoryProvider)
          .storeFilesToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
              file);

      String contactMessage;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMessage = '📷 Photo';
        case MessageEnum.video:
          contactMessage = '📹 Video';
        case MessageEnum.audio:
          contactMessage = '🎤 Audio';
        case MessageEnum.gif:
          contactMessage = 'GIF';

          break;
        default:
          contactMessage = 'GIF';
      }

      _saveDatatoContactSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          timeSent: timeSent,
          lastMessage: contactMessage,
          receiverUserId: receiverUserId);
      _saveDataToMessageSubCollection(
          messageId: messageId,
          receiverUserId: receiverUserId,
          timeSent: timeSent,
          text: imageUrl,
          senderUserName: senderUserData.name,
          receiverUserName: receiverUserData.name,
          messageType: messageEnum,
          messageReply: messageReply,
          );
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void sendGifMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageReply messageReply
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();
      UserModel receiverUserData;

      var userData =
          await firebaseFirestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userData.data()!);

      _saveDatatoContactSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          timeSent: timeSent,
          lastMessage: 'Gif',
          receiverUserId: receiverUserId);

      _saveDataToMessageSubCollection(
          messageId: messageId,
          receiverUserId: receiverUserId,
          timeSent: timeSent,
          text: gifUrl,
          messageReply: messageReply,
          senderUserName: senderUserData.name,
          receiverUserName: receiverUserData.name,
          messageType: MessageEnum.gif);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
