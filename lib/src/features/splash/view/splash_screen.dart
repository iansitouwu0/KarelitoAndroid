import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/providers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
  try {
    await ProgressManager().load();
    
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.loadCurrentUser();
    }

    if (mounted) {
      context.go('/home');
    }
  } catch (e) {
    debugPrint('Initialization error: $e');
    if (mounted) {
      context.go('/signin');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/home/karelito_logo.png', width: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Color(0xFF00D4FF)),
            const SizedBox(height: 20),
            const Text(
              'Cargando Karelito...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}