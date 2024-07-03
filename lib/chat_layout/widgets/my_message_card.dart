

import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';
import 'package:whatsapp_clone/chat_layout/widgets/display_text_image_gif.dart';
import 'package:whatsapp_clone/colors.dart';


class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final void Function(DragUpdateDetails)? onLeftSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;

  const MyMessageCard({Key? key, required this.message, required this.date, required this.type, required this.onLeftSwipe, required this.repliedText, required this.userName, required this.repliedMessageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    final isNotReplying = repliedText.isEmpty;
    return SwipeTo(
      onLeftSwipe:onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text? EdgeInsets.only(
                    left: 10,
                    right: 40,
                    top: 5,
                    bottom: 20,
                  ) : EdgeInsets.only(left: 5,right: 5,bottom: 30,top: 5),
                  child: Column(
                    children: [
                      if(isReplying)...[
                        Text(userName,style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                         Container(
                          
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: backgroundColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)
                          ),
                          child: DisplayTextImageGif(message: repliedText, type: repliedMessageType)),
                          SizedBox(height: 8,),
                      ],
                      if(isNotReplying)...[DisplayTextImageGif(message: message, type: type),]
                      
                    ],
                  )
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style:const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}