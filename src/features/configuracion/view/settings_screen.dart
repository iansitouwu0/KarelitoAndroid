import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../shared/views/views.dart';
import '../../../shared/controllers/controllers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final buttonHeight = height * 0.065;
    final spacing = height * 0.015;
    final bt = context.watch<BluetoothManager>(); 

    return Stack(
      children: [
        AdaptativeScreen(
          backgroundImage: 'assets/home/homeBg.jpg',
          titleImage: 'assets/configuracion/titleImage.png',
          height: height,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.01,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight * 1.1,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/settings/bluetooth'),
                        icon: Icon(
                          bt.isConnected
                              ? Icons.bluetooth_connected
                              : Icons.bluetooth_disabled,
                          color: Colors.white,
                        ),
                        label: Text(
                          bt.isConnected
                              ? 'Bluetooth · Conectado'
                              : 'Bluetooth · Desconectado',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              bt.isConnected ? Colors.green : Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: spacing * 1.5),
                    _sectionLabel('Controles'),
                    SizedBox(height: spacing),

                    _rowButtons(
                      ['LEFT', 'RUN', 'RIGHT'],
                      [Colors.blue, Colors.green, Colors.blue],
                      ['I', 'A', 'D'],
                      buttonHeight,
                      bt,
                    ),
                    SizedBox(height: spacing),
                    _rowButtons(
                      ['BUZZER'],
                      [Colors.orange],
                      ['S'],
                      buttonHeight,
                      bt,
                    ),

                    SizedBox(height: spacing * 1.5),
                    _sectionLabel('Calibración'),
                    SizedBox(height: spacing),

                    _rowButtons(
                      ['Calib.\nIzquierda', 'Calib.\n20cm', 'Calib.\nDerecha'],
                      [Colors.grey, Colors.grey, Colors.grey],
                      ['H', 'C', 'G'],
                      buttonHeight,
                      bt,
                    ),
                    SizedBox(height: spacing),
                    _rowButtons(
                      ['Desvío Iz', 'Desvío Dr'],
                      [Colors.teal, Colors.teal],
                      ['J', 'K'],
                      buttonHeight,
                      bt,
                    ),

                    SizedBox(height: spacing * 1.5),
                    _sectionLabel('Ajustes'),
                    SizedBox(height: spacing),

                    _rowButtons(
                      ['+Giro', '-Giro'],
                      [Colors.purple, Colors.purple],
                      ['+', '-'],
                      buttonHeight,
                      bt,
                    ),
                    SizedBox(height: spacing),
                    _rowButtons(
                      ['+CM', '-CM'],
                      [Colors.brown, Colors.brown],
                      ['J', 'K'],
                      buttonHeight,
                      bt,
                    ),
                    SizedBox(height: spacing),
                    _rowButtons(
                      ['+Freno', '-Freno'],
                      [Colors.red, Colors.red],
                      ['U', 'N'],
                      buttonHeight,
                      bt,
                    ),

                    SizedBox(height: spacing * 2),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Botón volver ──
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.go('/'),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _rowButtons(
    List<String> texts,
    List<Color> colors,
    List<String> data,
    double height,
    BluetoothManager bt, 
  ) {
    return Row(
      children: List.generate(texts.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              height: height,
              child: ElevatedButton(
                onPressed: bt.isConnected
                    ? () => bt.send(data[index])
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Conecta el Bluetooth primero!'),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors[index],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  texts[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}