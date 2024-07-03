import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';
import 'package:whatsapp_clone/utils/snack_bar.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
final TextEditingController _nameController = TextEditingController();

File? image;

@override
  void dispose() {
_nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:SafeArea(child: Center(
        child: Column(
          children: [
      SizedBox(height: 20,),
            Stack(
              children: [
              image != null ?  CircleAvatar(
                  maxRadius: 56,
                  backgroundImage: FileImage(image!),
                ) : CircleAvatar(
                  maxRadius: 65,
                  backgroundImage: NetworkImage(
                    'https://b2440849.smushcdn.com/2440849/wp-content/plugins/wp-social-reviews/assets/images/template/review-template/placeholder-image.png?lossy=1&strip=1&webp=1'
                    ),
                ),
                Positioned(
                  right: -10,bottom: -10,
                  child: IconButton(onPressed:() async{
                    image = await pickImageFromGallery(context);
                    print(image);
                    setState(() {
                      
                    });
                  }, icon: Icon(Icons.add_a_photo))
                  )
              ],
            ),
            Row(
              children: [
                Container(
                  width: width*0.8,
                 
               
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Name",
                    helperMaxLines: 50
                  ),
                ),
                ),
                SizedBox(width: 10,),
                IconButton(onPressed:() {
                  String name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    ref.read(authControllerProvider).saveUserDataToFirebase(context, name, image);
                  }
                }, icon: Icon(Icons.done))
              ],
            )
      
          ],
        ),
      ))
    );
  }
}