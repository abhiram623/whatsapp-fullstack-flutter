import 'package:flutter/material.dart';
import 'package:whatsapp_clone/chat_layout/screen/chatscreen.dart';
import 'package:whatsapp_clone/contact/screens/contact_screen.dart';
import 'package:whatsapp_clone/landing%20scrn/login_screen.dart';
import 'package:whatsapp_clone/landing%20scrn/otp_screen.dart';
import 'package:whatsapp_clone/landing%20scrn/user_screen.dart';
import 'package:whatsapp_clone/mobile_layout/screens/mobile_layout_screen.dart';
import 'package:whatsapp_clone/reusable_widgets/error.dart';
Route <dynamic> generateRoute (RouteSettings settings){
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder:(context) => LoginScreen(),);
      case OTPScreen.routeName:
    final  verificationId = settings.arguments as String;
      return MaterialPageRoute(builder:(context) => OTPScreen(verificationId: verificationId),); 
       case UserInformationScreen.routeName:
      return MaterialPageRoute(builder:(context) => UserInformationScreen(),);
      case MobileLayoutScreen.routeName:
      return MaterialPageRoute(builder:(context) => MobileLayoutScreen(),);
      case ChatScreen.routeName:
      final arguments = settings.arguments as Map<String,dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(builder:(context) => ChatScreen(name: name, uid: uid,),);
      case ContactScreen.routeName:
      return MaterialPageRoute(builder:(context) => ContactScreen(),);
    default:
    return MaterialPageRoute(builder:(context) =>Scaffold(body: ErrorScreen(error: "This Page Does not Exist"),) ,);
  }
}