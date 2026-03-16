
import 'package:flutter/material.dart';
import 'providers/theme.dart';
import 'router.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  final settings = ValueNotifier(
    ThemeSettings(sourceColor: Colors.pink, themeMode: ThemeMode.system),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routeInformationParser: appRouter.routeInformationParser,
        routeInformationProvider: appRouter.routeInformationProvider,
        routerDelegate: appRouter.routerDelegate,
                  
      );
    }
  }

