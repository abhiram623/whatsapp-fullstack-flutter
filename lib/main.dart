import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';
import 'package:whatsapp_clone/landing%20scrn/landing_screen.dart';
import 'package:whatsapp_clone/mobile_layout/screens/mobile_layout_screen.dart';
import 'package:whatsapp_clone/loader.dart';
import 'package:whatsapp_clone/reusable_widgets/error.dart';

import 'package:whatsapp_clone/router.dart';
import 'firebase_options.dart';
void main()async {


WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(ProviderScope(child: const MyApp()));
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(backgroundColor: appBarColor)
      ),
      onGenerateRoute:(settings) => generateRoute(settings),
      // home: LandingScreen(),
      home: ref.watch(userDataAuthProvider).when(
      data: (data) {
        // if (data!.connectionState == ConnectionState.waiting) {
        //   return Loader();
        // }
        if (data == null) {
          return LandingScreen();
        }
        return MobileLayoutScreen();
      },
      error:(error, stackTrace) => ErrorScreen(error: error.toString()),
     loading:() {
       return Loader();
     },),
    );
  }
}