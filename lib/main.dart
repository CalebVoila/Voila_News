import 'package:flutter/material.dart';
import 'package:voila_news/screens/main_screen.dart';
import 'package:voila_news/utils/theme.dart';

void main() {
  runApp(VoilaNewsApp());
}

class VoilaNewsApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voila News',
      theme: appTheme,
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}