import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_tac_toe/widget_tree.dart';
import '../services/auth.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut(BuildContext context) async{
    await Auth().signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WidgetTree()), (route) => false);
  }

  Widget _title(){
    return const Text('Firebase Auth');
  }

  Widget _userId(){
    return Text(user?.email ?? 'User eamil');
  }

  Widget _signOutButton(BuildContext context){
    return ElevatedButton(
        onPressed:() => signOut(context),
        child: const Text("Sign Out")
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userId(),
            _signOutButton(context)
          ],
        ),
      ),
    );
  }
}