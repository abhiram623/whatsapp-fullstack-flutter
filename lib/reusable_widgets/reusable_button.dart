import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class ReUsableButton extends StatelessWidget {
  const ReUsableButton({super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, 
    child:Text(text,style: TextStyle(fontSize: 17),),
    style: ElevatedButton.styleFrom(backgroundColor: tabColor,
    minimumSize: Size(double.infinity, 50)
    ),
    );
  }
}