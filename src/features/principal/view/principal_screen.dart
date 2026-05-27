import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../shared/views/views.dart';
import '../../../shared/controllers/controllers.dart';
import '../../../shared/providers/progress_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bt = context.watch<BluetoothManager>();
    final progress = context.watch<ProgressManager>();

    return AdaptativeScreen(
      backgroundImage: 'assets/home/homeBg.jpg',
      titleImage: 'assets/home/homeTitle.png',
      height: height,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: height * 0.45,
              child: ElevatedButton(
                onPressed: () => context.go('/levelView'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: height * 0.03),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(
                    fontSize: height * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Jugar'),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: height * 0.45,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Puntos totales',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${progress.totalScore}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: height * 0.45,
              child: OutlinedButton(
                onPressed: () => context.go('/stats'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white70),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: height * 0.023),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(
                    fontSize: height * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Estadísticas'),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: height * 0.07,
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () => context.go('/settings'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        bt.isConnected
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth_disabled,
                        color: bt.isConnected ? Colors.greenAccent : Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        bt.isConnected ? 'Conectado' : 'Sin conexión',
                        style: TextStyle(
                          color: bt.isConnected ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}