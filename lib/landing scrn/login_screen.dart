import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Styles/styles.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/controller/auth_controller.dart';
import 'package:whatsapp_clone/reusable_widgets/reusable_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whatsapp_clone/utils/snack_bar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController _phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Enter Your Phone Number",
          style: Styles.titleMedium,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
                const SizedBox(height: 20,),
            const Center(child: Text("WhatsApp will need to verify your phone number",style: Styles.textSmall,)),
            const SizedBox(height: 18,),
            TextButton(onPressed: (){
           showCountryPicker(context: context,
              showPhoneCode: true,
               onSelect: (value) {
                setState(() {
                  country = value;
                });
                
              },);
            }, child: Text("Pick Your Country")),
            const SizedBox(height: 18,),
            SizedBox(
              width: width * 0.9,
              child: Row(
                children: [
                  if(country != null)
                  Text("+${country!.phoneCode}"),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(hintText: "phone Number"),
                    ),
                  ),
                ],
              )),
            ],),
          ),
          
          Column(
            children: [
              SizedBox(
                width: width*0.85,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ReUsableButton(text: "Next", onPressed:() {
                   final phoneNumber = _phoneController.text.trim();
                   if (country != null && phoneNumber.isNotEmpty) {
                     ref.read(authControllerProvider).signInWithPhone("+${country!.phoneCode}$phoneNumber", context);
                   }else{
                    showSnackBar("Fill out all the fields", context);
                   }
                  },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}