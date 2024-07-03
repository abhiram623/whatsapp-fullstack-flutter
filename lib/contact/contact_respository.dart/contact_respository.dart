import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat_layout/screen/chatscreen.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/utils/snack_bar.dart';

final selectContactRespositoryProvider = Provider((ref) {
  return SelectContactRespository(firebaseFirestore: FirebaseFirestore.instance);
});

class SelectContactRespository {
final FirebaseFirestore firebaseFirestore;

  SelectContactRespository({required this.firebaseFirestore});

  Future<List<Contact>> getContacts()async{
    List<Contact> contacts = [];
    try {

      if (await FlutterContacts.requestPermission()) {
      contacts =    await FlutterContacts.getContacts(withProperties: true);
      }


    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }  

  void selectContact (Contact selectedContact,BuildContext context)async{
try {

  var userCollection =await firebaseFirestore.collection('users').get();
  bool isFound = false;

  for (var doc in userCollection.docs) {
    var userdata = UserModel.fromMap(doc.data());
    String selectedNum = selectedContact.phones[0].number.replaceAll(' ', '');
    if (selectedNum == userdata.phoneNumber) {
      isFound = true;
      Navigator.pushNamed(context, ChatScreen.routeName,arguments: {
        'name': userdata.name,
        'uid' : userdata.uid
        
      });
    }
  }
  if (!isFound) {
    showSnackBar("This number doesn't exist on this app", context);
  }

  
} catch (e) {
  showSnackBar(e.toString(), context);
}
  }
}