import 'package:flutter/material.dart';
import 'views/patisserie_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pâtisserie App',
        debugShowCheckedModeBanner: false,
        home: PatisserieScreen(),
      );
   }
  }
