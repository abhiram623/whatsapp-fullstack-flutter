import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';
import 'package:whatsapp_clone/chat_layout/widgets/display_text_image_gif.dart';
import 'package:whatsapp_clone/colors.dart';


class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date, required this.type, this.onRightSwipe, required this.repliedText, required this.userName, required this.repliedMessageType,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final void Function(DragUpdateDetails)? onRightSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
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
                  child: DisplayTextImageGif(message: message, type: type)
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
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