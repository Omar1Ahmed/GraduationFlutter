import 'package:flutter/material.dart';
import 'package:learning/Widgets/LoginWidget.dart';

void main (){
  runApp(MainApp());
}

class MainApp extends StatefulWidget{
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF272A37),
        body: Login(),
        // Grad(),
    )
    );
  }

}

