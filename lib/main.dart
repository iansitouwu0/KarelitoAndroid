import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/shared/router.dart';
import 'src/shared/controllers/controllers.dart';
import 'src/shared/providers/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize ProgressManager
  await ProgressManager().load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothManager()),
        ChangeNotifierProvider(create: (_) => ProgressManager()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),  // NEW
        ChangeNotifierProvider(create: (_) => UserProvider()),  // NEW
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





