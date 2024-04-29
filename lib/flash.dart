import 'dart:async';
import 'package:flutter/material.dart';
import 'main_menu.dart';

class LogoDisplay extends StatefulWidget {
  @override
  _LogoDisplayState createState() => _LogoDisplayState();
}

class _LogoDisplayState extends State<LogoDisplay> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      goToLandingPage();
    });
  }

  void goToLandingPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252872),
      body: Center(
        child: Image.asset(
          'images/logo.png',
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
