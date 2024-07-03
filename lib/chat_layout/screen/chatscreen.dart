import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat_layout/widgets/chat_list.dart';
import 'package:whatsapp_clone/chat_layout/widgets/chat_text_field.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';
import 'package:whatsapp_clone/loader.dart';
import 'package:whatsapp_clone/models/user_model.dart';


class ChatScreen extends ConsumerWidget {
  static const String routeName = '/chat-screen';
  const ChatScreen({super.key, required this.name, required this.uid});
  final String name;
  final String uid;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.watch(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                ),
                Text(
                  snapshot.data!.isOnline ? "Online" : "Offline",style: TextStyle(fontSize: 14),
                ),
              ],
            );
          }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(uid),
          ),
          ChatTextField(uid),
        ],
      ),
    );
  }
}
