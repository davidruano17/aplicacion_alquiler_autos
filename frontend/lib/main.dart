import 'package:flutter/material.dart';
import 'views/loginScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alquiler de Autos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF60B5FF),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
