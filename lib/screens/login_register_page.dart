import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_tac_toe/screens/forgot_password_page.dart';
import 'package:tic_tac_toe/screens/phone_signin.dart';
import 'package:tic_tac_toe/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _underProgress = false;
  String? errorMessage = '';
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async{
    try{
      setState(() {
        _underProgress = true;
      });
      if(_formKey.currentState!.validate()){
        await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      }
      setState(() {
        _underProgress = false;
      });
    }on FirebaseAuthException catch(e){
      setState(() {
        errorMessage = e.message;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage ?? 'Something went Wrong'),
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 4,
        showCloseIcon: true,
        closeIconColor: Colors.deepPurple,
      ));
      setState(() {
        _underProgress = false;
      });
    }
  }

  Future<void> signInWithGoogle() async{
    try{
      setState(() {
        _underProgress = true;
      });
      await Auth().signInWithGoogle();
      setState(() {
        _underProgress = false;
      });
      print('12345');
    }on FirebaseAuthException catch(e){
      setState(() {
        errorMessage = e.message;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage ?? 'Something went Wrong'),
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 4,
        showCloseIcon: true,
        closeIconColor: Colors.deepPurple,
      ));
      setState(() {
        _underProgress = false;
      });
    }
  }


  Future<void> createUserWithEmailAndPassword() async{
    try{
      setState(() {
        _underProgress = true;
      });
      if(_formKey.currentState!.validate()){
        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      }
      setState(() {
        _underProgress = false;
      });
    }on FirebaseAuthException catch(e){
      setState(() {
        errorMessage = e.message;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage ?? 'Something went Wrong'),
        backgroundColor: Colors.deepPurple.shade200,
        elevation: 4,
        showCloseIcon: true,
        closeIconColor: Colors.deepPurple,
      ),);
      setState(() {
        _underProgress = false;
      });
    }
  }

  // Widget _title(){
  //   return const Text("Firebase Auth");
  // }

  Widget _entryField({
    required String title,
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
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
          }
          return null;
        },
      ),
    );
  }

  // Widget _errorMessage(){
  //   return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  // }

  Widget _submitButton(){
    return (_underProgress)
        ? CircularProgressIndicator()
        : ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        child: Text(isLogin ? 'Login' : 'Register')
    );
  }

  Widget _loginOrRegistrationButton(){
    return TextButton(
        onPressed: (){
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register instead' : 'Login instead')
    );
  }

  Widget _entryMessage(){
    return Text(
      "Please Sign In to Access the App",
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white),
    );
  }

  Widget _loginOptionsButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhoneSignin()));
          },
          child: const CircleAvatar(
            backgroundColor: Colors.deepPurple,
            radius: 30,
            backgroundImage: AssetImage('assets/images/phone_logo.png'),
          ),
        ),
        const SizedBox(width: 10,),
        InkWell(
          onTap: (){
          },
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 33,
            backgroundImage: AssetImage('assets/images/facebook_logo.png'),
          ),
        ),
        const SizedBox(width: 10,),
        InkWell(
          onTap: ()async{
            await signInWithGoogle();
          },
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 33,
            backgroundImage: AssetImage('assets/images/google_logo.png'),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: _title(),
      // ),
      body: Form(
        key: _formKey,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple,
                Colors.white
              ]
            )
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _entryMessage(),
                  const SizedBox(height: 20,),
                  _entryField(
                      title: 'email',
                      controller: _controllerEmail,
                      icon: const Icon(Icons.person,color: Colors.white,),
                    hintText: "Enter email",
                    labelText: "Email",
                    validationText: "Please enter your mail",
                    obscureText: false,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10,),
                  _entryField(
                      title: 'password',
                      controller: _controllerPassword,
                      icon: Icon(Icons.password,  color: Colors.white,),
                    hintText: "Enter password",
                    labelText: 'Password',
                    validationText: "Please enter your password",
                    obscureText: true,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done
                  ),
                  // _errorMessage(),
                  _submitButton(),
                  _loginOrRegistrationButton(),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                      },
                      child: Text('Forgot Password')
                  ),
                  const SizedBox(height: 20,),
                  _loginOptionsButtons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
