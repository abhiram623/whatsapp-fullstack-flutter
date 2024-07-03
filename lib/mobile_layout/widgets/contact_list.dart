import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat_layout/controller/chat_controller.dart';
import 'package:whatsapp_clone/chat_layout/models/chat_contact_model.dart';
import 'package:whatsapp_clone/chat_layout/screen/chatscreen.dart';
import 'package:whatsapp_clone/colors.dart';

import 'package:intl/intl.dart';
import 'package:whatsapp_clone/loader.dart';


class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).getChatContact(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ChatScreen.routeName,arguments: {
                        'name' : snapshot.data![index].name,
                        'uid' : snapshot.data![index].contactId
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          snapshot.data![index].name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            snapshot.data![index].lastMessage,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data![index].profilePic,
                          ),
                          radius: 30,
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(snapshot.data![index].timeSent),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              );
            },
          );
        }
      ),
    );
  }
}