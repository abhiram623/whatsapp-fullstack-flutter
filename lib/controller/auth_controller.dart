import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/respository/auth_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userDataAuthProvider = FutureProvider((ref) async {

  return ref.watch(authRespositoryProvider).getCurrentUserData();
});

final authControllerProvider = Provider((ref) {
  final authRespository = ref.watch(authRespositoryProvider);
  return AuthController(authRespository: authRespository, ref: ref);
});


class AuthController {
  final AuthRespository authRespository;
  final ProviderRef ref;

  AuthController({required this.authRespository,required this.ref});
  Stream<UserModel> userDataById(String userId){
   return authRespository.userData(userId);
  }


  void signInWithPhone(String phoneNumber,BuildContext context){
      authRespository.signInWithPhone(phoneNumber, context);
  }

  void verifyOTP (BuildContext context,String verificationId,String smsCode){
    authRespository.verifyOTP(context, verificationId, smsCode);

  }
  void saveUserDataToFirebase(BuildContext context,String name,File? profilePic){
   authRespository.saveDatatoFirebase(context, ref, name, profilePic);
  }
  void setUserAppState(bool isOnline)async{
    authRespository.setUserAppState(isOnline);
  }
}