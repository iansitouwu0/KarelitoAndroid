import 'package:flutter/material.dart';
import 'nivel_screen.dart';
import '../../../shared/providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LevelScreen(level: Levels.tutorial),
    );
  }
}