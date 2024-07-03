import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/chat_layout/controller/chat_controller.dart';
import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';
import 'package:whatsapp_clone/chat_layout/messreply/provider/message_reply_provider.dart';
import 'package:whatsapp_clone/chat_layout/models/message_model.dart';
import 'package:whatsapp_clone/chat_layout/widgets/my_message_card.dart';
import 'package:whatsapp_clone/chat_layout/widgets/sender_message_card.dart';

import 'package:whatsapp_clone/loader.dart';


class ChatList extends ConsumerStatefulWidget {
 final String receiverUserId;
  const ChatList(this.receiverUserId, {Key? key}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  final ScrollController messageScrollController = ScrollController();

  @override
  void dispose() {
    messageScrollController.dispose();
    super.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum
  ){
    ref.read(messagReplyProvider.notifier).update((state) => MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: ref.read(chatControllerProvider).getChatStream(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageScrollController.jumpTo(messageScrollController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageScrollController,
          itemCount:snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            if (snapshot.data![index].senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: snapshot.data![index].text,
                date: DateFormat.Hm().format(snapshot.data![index].time), 
                type: snapshot.data![index].type,
                repliedText: messageData.repliedMessage,
                userName: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onLeftSwipe:(details) {
                 onMessageSwipe(messageData.text, true, messageData.type);
                 },
              );
            }
            return SenderMessageCard(
              type: snapshot.data![index].type,
              message: snapshot.data![index].text,
              date: DateFormat.Hm().format(snapshot.data![index].time),
              repliedText: messageData.repliedMessage,
                userName: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightSwipe:(details) {
                 onMessageSwipe(messageData.text, false, messageData.type);
                 }
            );
          },
        );
      }
    );
  }
}