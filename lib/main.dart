import 'package:flutter/material.dart';
import 'package:chedapplication/flash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHED RO XI',
      theme: ThemeData(
        // Color(0xFF252872)
        primarySwatch: MaterialColor(
          0xFF252872,
          {
            50: Color(0xFF252872),
            100: Color(0xFF252872),
            200: Color(0xFF252872),
            300: Color(0xFF252872),
            400: Color(0xFF252872),
            500: Color(0xFF252872),
            600: Color(0xFF252872),
            700: Color(0xFF252872),
            800: Color(0xFF252872),
            900: Color(0xFF252872),
          }
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogoDisplay(),
    );
  }
}