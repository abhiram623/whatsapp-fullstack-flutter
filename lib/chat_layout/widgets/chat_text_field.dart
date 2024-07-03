import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/chat_layout/controller/chat_controller.dart';
import 'package:whatsapp_clone/chat_layout/enum/message_enum.dart';
import 'package:whatsapp_clone/chat_layout/messreply/provider/message_reply_provider.dart';
import 'package:whatsapp_clone/chat_layout/messreply/widget/message_reply_preview.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/utils/snack_bar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatTextField extends ConsumerStatefulWidget {
  const ChatTextField(
    this.uid, {
    super.key,
  });
  final String uid;

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  final TextEditingController _chatcontroller = TextEditingController();
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  bool isrecording = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;
  @override
  void initState() {
    _soundRecorder = FlutterSoundRecorder();
    super.initState();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic Permission not allowed");
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void hideKeyboard() {
    focusNode.unfocus();
  }

  void toggleEmojiKeyboard() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    _chatcontroller.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
    super.dispose();
  }

  bool isShowButton = false;

  void sendTextMessages() async {
    if (isShowButton) {
      ref
          .read(chatControllerProvider)
          .sendTextMessages(context, _chatcontroller.text.trim(), widget.uid);
      setState(() {
        _chatcontroller.text = '';
      });
    }else{
      var temDirec = await getTemporaryDirectory();
      var path = '${temDirec.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isrecording) {
      await  _soundRecorder!.stopRecorder();
      sendFileMessage(File(path), MessageEnum.audio);
      }else{
        await _soundRecorder!.startRecorder(
          toFile: path
        );
      }
      setState(() {
        isrecording = !isrecording;
      });
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.uid, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGif() async {
    final gif = await pickGif(context);
    if (gif != null) {
      ref
          .read(chatControllerProvider)
          .sendGifMessage(context, gif.url, widget.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final messageReply = ref.watch(messagReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        isShowMessageReply ? MessageReplyPreview() : SizedBox(),
        Row(
          children: [
            SizedBox(
              width: width * 0.85,
              child: TextFormField(
                focusNode: focusNode,
                controller: _chatcontroller,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isShowButton = true;
                    });
                  } else {
                    setState(() {
                      isShowButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: toggleEmojiKeyboard,
                              icon: Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              )),
                          IconButton(
                              onPressed: selectGif,
                              icon: Icon(
                                Icons.gif,
                                color: Colors.grey,
                                size: 35,
                              )),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              selectVideo();
                            },
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                              size: 25,
                            )),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
              child: GestureDetector(
                onTap: () {
                  sendTextMessages();
                },
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF128C7E),
                  child: Icon(
                    isShowButton ? Icons.send :isrecording? Icons.close: Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _chatcontroller.text = _chatcontroller.text + emoji.emoji;
                    });
                    if (!isShowButton) {
                      setState(() {
                        isShowButton = true;
                      });
                    }
                  },
                ),
              )
            : SizedBox()
      ],
    );
  }
}
