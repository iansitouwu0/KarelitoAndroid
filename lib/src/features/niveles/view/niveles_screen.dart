import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/providers/progress_manager.dart';
import '../../../shared/views/views.dart';
import '../../../shared/controllers/controllers.dart';
import '../view/niveles_nivel.dart';

class NivelesScreen extends StatelessWidget {
  const NivelesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final niveles = NivelesProvider().niveles;
    final bt = context.watch<BluetoothManager>();
    // Escucha cambios de progreso para redibujar estrellas/candados
    final progress = context.watch<ProgressManager>();

    // Mezcla los datos estáticos con el progreso guardado
    final nivelesConProgreso = niveles.map((n) {
      return n.copyWith(
        stars: progress.getStars(n.id),
        locked: !progress.isUnlocked(n.id),
      );
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/home/homeBg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white),
                            onPressed: () => context.go('/'),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
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
                                  color: bt.isConnected
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  bt.isConnected
                                      ? 'Conectado'
                                      : 'Sin conexión',
                                  style: TextStyle(
                                    color: bt.isConnected
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    const TitleCard(text: 'NIVELES'),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: VistaNiveles(
                          niveles: nivelesConProgreso,
                          constraints: constraints,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
