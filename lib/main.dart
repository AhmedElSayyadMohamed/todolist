import 'package:flutter/material.dart';
import 'package:to_do_1/layout/layout_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: layout_screen(),
    );
  }
}
