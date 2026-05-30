import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/shared/router.dart';
import 'src/shared/controllers/controllers.dart';
import 'src/shared/providers/progress_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BluetoothManager(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgressManager(),
        ),
      ],
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





