import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

import 'niveles_screen.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Niveles',
        theme: ThemeData(
          useMaterial3: true,  
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: NivelesPreview(),
      ),
    );
  }
}
class MyAppState extends ChangeNotifier {

}

class NivelesPreview extends StatefulWidget {
  @override
  State<NivelesPreview> createState() =>_NivelesPreviewState();
}

class _NivelesPreviewState extends State<NivelesPreview> {
   @override
  Widget build(BuildContext context) {
    return NivelesScreen();
  } 
}