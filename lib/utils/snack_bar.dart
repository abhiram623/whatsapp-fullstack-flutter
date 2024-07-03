import 'dart:io';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar (String content,BuildContext context){
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImageFromGallery (BuildContext context)async{
File? image;
try {
  final pickedImage =await ImagePicker().pickImage(source:ImageSource.gallery);

if (pickedImage != null) {
  image = File(pickedImage.path);
}

} catch (e) {
  showSnackBar(e.toString(), context);
}
return image;
}



Future<File?> pickVideoFromGallery (BuildContext context)async{
File? video;
try {
  final pickedVideo =await ImagePicker().pickVideo(source:ImageSource.gallery);

if (pickedVideo != null) {
  video = File(pickedVideo.path);
}

} catch (e) {
  showSnackBar(e.toString(), context);
}
return video;
}

Future<GiphyGif?> pickGif(BuildContext context)async{
  // G9Vg5x4mn5m6F8LQWTrasTisqSBYjBP2
  GiphyGif? gif;
try {
 gif =  await Giphy.getGif(context: context, apiKey: 'G9Vg5x4mn5m6F8LQWTrasTisqSBYjBP2');
 
} catch (e) {
  showSnackBar(e.toString(), context);
}
return gif;
}

