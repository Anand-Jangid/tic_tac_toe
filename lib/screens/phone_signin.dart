import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/verification_screen.dart';
import 'package:tic_tac_toe/services/auth.dart';

class PhoneSignin extends StatefulWidget {
  const PhoneSignin({Key? key}) : super(key: key);

  @override
  State<PhoneSignin> createState() => _PhoneSigninState();
}

class _PhoneSigninState extends State<PhoneSignin> {

  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  Widget _textField({
    required TextEditingController controller,
    required Icon icon,
    required String hintText,
    required String labelText,
    required String validationText,
    required bool obscureText,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
  }){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Colors.white
          ),
            hintText: hintText,
            labelText: labelText,
            contentPadding: const EdgeInsets.all(8),
            prefixIcon: icon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
            )
        ),
        validator: (value){
          if(value == null || value.isEmpty){
            return validationText;
          }else if(value.length < 10 || value.length > 10){
            return "Phone Number should be of 10 digits";
          }
          return null;
        },
      ),
    );
  }

  Widget _submitButton(){
    return ElevatedButton(
        onPressed: (){
          if(_formKey.currentState!.validate()){
            _createUserWithPhoneNumber(phoneNumber: _phoneController.text);
          }
        },
        child: Text("Verify my number")
    );
  }

  final _phoneController = TextEditingController();

  // void callbackFunction(PhoneAuthCredential phoneAuthCredential){
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerificationScreen(verificationId: ,)));
  // }

  void callbackCodesent(String verificationId, int? token){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerificationScreen(verificationId: verificationId)));
  }

  Future<void> _createUserWithPhoneNumber({required String phoneNumber}) async{
    try{
      await Auth().createUserWithPhoneNumber(phoneNumber: '+91$phoneNumber', callbackCodeSent:  callbackCodesent);
    }on FirebaseAuthException catch(e){
      setState(() {
        errorMessage = e.message ?? '';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage ?? 'Something went Wrong'),
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 4,
        showCloseIcon: true,
        closeIconColor: Colors.deepPurple,
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepOrangeAccent,
                Colors.deepPurpleAccent
              ]
            )
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login via Pnone Number", style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white),),
                const SizedBox(height: 20,),
                const Icon(Icons.phone_android_outlined, size: 100, color: Colors.white,),
                const SizedBox(height: 20,),
                _textField(
                    controller: _phoneController,
                    icon: const Icon(Icons.call),
                    hintText: "Please enter your phone number",
                    labelText: "Phone number",
                    validationText: "Please enter your phone number",
                    obscureText: false,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.done),
                const SizedBox(height: 40,),
                _submitButton(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
