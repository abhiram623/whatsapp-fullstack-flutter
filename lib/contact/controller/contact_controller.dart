import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/contact/contact_respository.dart/contact_respository.dart';

final contactControllerProvider = Provider((ref) {
  return ContactController(ref, contactRespository: ref.watch(selectContactRespositoryProvider));
});

final getContactsControllerProvider = FutureProvider((ref) async {
  return ref.watch(selectContactRespositoryProvider).getContacts();
});

class ContactController {
  final SelectContactRespository contactRespository;
  final ProviderRef ref;

  ContactController(this.ref, {required this.contactRespository});

  void selectContact (Contact selectedContact,BuildContext context){
    contactRespository.selectContact(selectedContact, context);
  }
}