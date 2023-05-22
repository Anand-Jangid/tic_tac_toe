import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/home_page.dart';
import 'package:tic_tac_toe/services/auth.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;

  @override
  _VerificationScreenState createState() => _VerificationScreenState();

  const VerificationScreen({super.key, required this.verificationId});
}

class _VerificationScreenState extends State<VerificationScreen> {
  late List<TextEditingController> _codeControllers;
  late List<FocusNode> _focusNodes;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _focusNextField(int index) {
    if (index < _codeControllers.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  void _focusPreviousField(int index) {
    if (index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  Future<void> _verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  })async{
    try{
      await Auth().verifyPhoneNumber(verificationId: verificationId, smsCode: smsCode);
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
      appBar: AppBar(
        title: Text('SMS Verification'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.deepOrangeAccent
                ]
            )
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Verify the SMS code", style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white),),
                const SizedBox(height: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                        (index) => Container(
                      width: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: TextFormField(
                        controller: _codeControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _focusNextField(index);
                          } else {
                            _focusPreviousField(index);
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async{
                    String verificationCode = _codeControllers
                        .map((controller) => controller.text)
                        .join();

                    // Add your logic for code verification
                    await _verifyPhoneNumber(verificationId: widget.verificationId , smsCode: verificationCode);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                  },
                  child: Text('Verify'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

