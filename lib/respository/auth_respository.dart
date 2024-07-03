import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/mobile_layout/screens/mobile_layout_screen.dart';

import 'package:whatsapp_clone/landing%20scrn/otp_screen.dart';
import 'package:whatsapp_clone/landing%20scrn/user_screen.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/respository/common_firebasestorage.dart';
import 'package:whatsapp_clone/utils/snack_bar.dart';

final authRespositoryProvider = Provider((ref) {
  return AuthRespository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
});

class AuthRespository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRespository({required this.auth, required this.firestore});

  void setUserAppState(bool isOnline)async{
   await firestore.collection('users').doc(auth.currentUser!.uid).update({
    'isOnline' : isOnline,
   });
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  Future<UserModel?> getCurrentUserData() async {
    final userData =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(String phoneNumber, BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationId);

          //   String smsCode = 'xxxx';
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void verifyOTP(
      BuildContext context, String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      await auth.signInWithCredential(credential);
      Navigator.pushNamed(context, UserInformationScreen.routeName);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void saveDatatoFirebase(BuildContext context, ProviderRef ref, String name,
      File? profilePic) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://b2440849.smushcdn.com/2440849/wp-content/plugins/wp-social-reviews/assets/images/template/review-template/placeholder-image.png?lossy=1&strip=1&webp=1';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebseStorageRespositoryProvider)
            .storeFilesToFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MobileLayoutScreen(),
          ),
          (route) => false);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
