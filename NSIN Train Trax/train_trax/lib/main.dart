import 'package:train_trax/screens/home/Homepage.dart';
import 'package:train_trax/utils/ourTheme.dart';
import 'package:train_trax/screens/login/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: OurTheme().buildTheme(),
      home: OurLogin(),
    );
  }
}
