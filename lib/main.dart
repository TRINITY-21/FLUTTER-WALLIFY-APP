import 'package:flutter/material.dart';
import 'package:Wallpaper_App/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:Color(0xFF1B1B1B),
        brightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}
