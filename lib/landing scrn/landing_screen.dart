import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Styles/styles.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/landing%20scrn/login_screen.dart';
import 'package:whatsapp_clone/reusable_widgets/reusable_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [
          Center(child: Text("Welcome to WhatsApp",style: Styles.headLineLarge,)),
SizedBox(height: 80,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/bg.png",color: tabColor,
          ),
        ),
        SizedBox(height: 90,),
        Center(child: Text('Read our Privacy policy.Tap "Agree and continue" to accept the Terms of Service',textAlign: TextAlign.center,)),
        SizedBox(height: 30,),
        SizedBox(
          width: width*0.85,
          child: ReUsableButton(text: "Accept and continue",onPressed: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },),
        )
        ],
      ),
    );
  }
}