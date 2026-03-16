import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'src/shared/router.dart';
import 'src/shared/controllers/controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(
    ChangeNotifierProvider.value(
      value: BluetoothManager(),  
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Karelito',
      theme: ThemeData(useMaterial3: true),
    );
  }
}