import 'package:tic_tac_toe/screens/play_page.dart';

import 'services/auth.dart';
import '../screens/home_page.dart';
import '../screens/login_register_page.dart';
import 'package:flutter/material.dart';


class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChange,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return HomePage();
        }else{
          return const LoginPage();
        }
      },
    );
  }
}


