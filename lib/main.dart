import 'package:flutter/material.dart';

import 'views/splashpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookBytes',
      theme: ThemeData.dark(
          //primarySwatch: Colors.blue,
          ),
      home: const SplashPage(),
    );
  }
}
