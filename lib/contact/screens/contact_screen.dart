import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/contact/controller/contact_controller.dart';
import 'package:whatsapp_clone/loader.dart';
import 'package:whatsapp_clone/reusable_widgets/error.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});
  static const String routeName = '/contact-screen';

  void selectContact (WidgetRef ref,BuildContext context,Contact selectedContact){
    ref.read(contactControllerProvider).selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Contacts")),
      body: ref.watch(getContactsControllerProvider).when(
        data: (contacts) {
          return ListView.builder(
            itemCount: contacts.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    selectContact(ref, context, contacts[index]);
                  },
                  child: ListTile(
                    title: Text(contacts[index].displayName),
                    leading: contacts[index].photo == null ? CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  'https://b2440849.smushcdn.com/2440849/wp-content/plugins/wp-social-reviews/assets/images/template/review-template/placeholder-image.png?lossy=1&strip=1&webp=1'),
                            )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage: MemoryImage(contacts[index].photo!),
                          ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        },
        loading: () {
          return Loader();
        },
      ),
    );
  }
}
