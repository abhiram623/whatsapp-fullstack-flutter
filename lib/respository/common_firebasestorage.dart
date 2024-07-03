import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebseStorageRespositoryProvider = Provider((ref) {
  return CommonFirebaseStorageRespository(firebaseStorage: FirebaseStorage.instance);
});

class CommonFirebaseStorageRespository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRespository({required this.firebaseStorage});

  Future <String> storeFilesToFirebase (String ref,File file)async{
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);

    TaskSnapshot snap = await uploadTask;
    String downLoadUrl =await snap.ref.getDownloadURL();
    return downLoadUrl;

  }
}