import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat_layout/messreply/provider/message_reply_provider.dart';
import 'package:whatsapp_clone/chat_layout/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelMessage(WidgetRef ref){
    ref.read(messagReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
   final messageReply =  ref.watch(messagReplyProvider);
    return Container(
      width: 350,
      decoration: BoxDecoration(color: Colors.transparent,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: Text(messageReply!.isMe ? "Me" : "Opposite",style: TextStyle(color: Colors.white),)),
            GestureDetector(
              onTap:()=> cancelMessage(ref),
              child: Icon(Icons.close,size: 16,),
            )
          ],),
          SizedBox(height: 8,),
          DisplayTextImageGif(message: messageReply.message, type: messageReply.messageEnum)
        ],
      ),
    );
  }
}