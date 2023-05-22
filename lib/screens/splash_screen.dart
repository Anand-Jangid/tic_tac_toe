import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/widget_tree.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4,), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WidgetTree()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/gif/animation2.gif',
                fit: BoxFit.cover,
              ),
            ),
          ],
        )
    );
  }
}