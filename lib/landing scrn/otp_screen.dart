import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget{
  const OTPScreen({super.key, required this.verificationId});
  static const String routeName = '/otp-screen';
  final String verificationId;

 void verifyOTP (WidgetRef ref, BuildContext context,String smsCode){
ref.read(authControllerProvider).verifyOTP(context, verificationId, smsCode);
 }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Center(child: Text("Verifying your number")),
        actions: [Text("ghjyjgff",style: TextStyle(color: backgroundColor),),],
      ),
      body: Column(children: [
        SizedBox(height: 40,),
        Center(child: Text("We have sent an SMS with a code")),
           SizedBox(
            width: width*0.4,
             child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                
                hintText: "- - - - - -",
                 hintStyle: TextStyle(fontSize: 35)
              ),
              onChanged: (value) {
                if (value.length == 6) {
                  verifyOTP(ref, context, value.trim());
                }
              },
             ),
           )
      ],)
    );
  }
}