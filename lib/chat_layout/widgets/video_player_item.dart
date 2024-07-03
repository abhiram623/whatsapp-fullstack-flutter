import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
 
 late CachedVideoPlayerController videoPlayerController;
 bool isPlay = false;

 @override
  void initState() {
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)..initialize().then((value) {
      videoPlayerController.setVolume(1);
    });
    super.initState();
  }
  @override
  void dispose() {
    videoPlayerController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 16/9,
    child: Stack(children: [
     CachedVideoPlayer(videoPlayerController),
     Center(child: IconButton(onPressed: (){
if (isPlay ) {
  videoPlayerController.pause();
}else{
  videoPlayerController.play();
}
setState(() {
  isPlay = !isPlay;
});

     }, icon: Icon(isPlay ? Icons.pause: Icons.play_circle)))
    ],),
    );
  }
}