import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/chat_layout/controller/chat_controller.dart';

import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/contact/screens/contact_screen.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';
import 'package:whatsapp_clone/mobile_layout/widgets/contact_list.dart';



class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const String routeName = '/mobile-layout-screen';
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
       ref.read(authControllerProvider).setUserAppState(true);
        break;
      case AppLifecycleState.detached:  
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      ref.read(authControllerProvider).setUserAppState(false);
        break;
      default:
      
      
    }
  }

  void signOut()async{
 ref.read(chatControllerProvider).signOut(context);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed:signOut
              
              ,
            ),
          ],
          bottom: const TabBar(
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          Navigator.pushNamed(context,ContactScreen.routeName );
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}