import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CarHisabApp());
}

class CarHisabApp extends StatelessWidget {
  const CarHisabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Hisab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto', // You can add Bengali font if needed
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
