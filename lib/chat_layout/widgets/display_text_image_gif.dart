import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:whatsapp_clone/chat_layout/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  const DisplayTextImageGif(
      {super.key, required this.message, required this.type});
  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(
              builder: (context,setState) {
                return IconButton(
                    constraints: BoxConstraints(minWidth: 100),
                    onPressed: () async{
                     if (isPlaying) {
                      await audioPlayer.pause();
                      setState((){
                       isPlaying = false;
                      });
                     }else{
                      await audioPlayer.play(UrlSource(message));
                       setState((){
                       isPlaying = true;
                      });
                     }
                    },
                    icon: Icon(isPlaying ? Icons.pause_circle:Icons.play_circle));
              }
            )
            : type == MessageEnum.video
                ? VideoPlayer(videoUrl: message)
                : type == MessageEnum.gif
                    ? CachedNetworkImage(imageUrl: message)
                    : CachedNetworkImage(imageUrl: message);
  }
}
