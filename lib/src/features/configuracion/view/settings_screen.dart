import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../../shared/views/views.dart';
import '../../../shared/controllers/controllers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
 
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final buttonHeight = height* 0.065;
    final spacing = height* 0.015;
    return  AdaptativeScreen(
      backgroundImage: 'home/homeBg.jpg',
      titleImage: "configuracion/titleImage.png",
      height: height,
      children: [
                      SingleChildScrollView(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  children: [
                    _bigButton("Bluetooth", Colors.indigo, buttonHeight),

                    SizedBox(height: spacing),

                    _rowButtons(
                      ["LEFT", "RUN", "RIGHT"],
                      [Colors.blue, Colors.green, Colors.blue],
                      buttonHeight,
                    ),

                    SizedBox(height: spacing),

                    _bigButton("BUZZER", Colors.orange, buttonHeight),

                    SizedBox(height: spacing * 1.5),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          "METAL NOT DETECTED",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: spacing * 1.5),

                    _rowButtons(
                      [
                        "Calibración\nIzquierda",
                        "Calibración\n20cm",
                        "Calibración\nDerecha",
                      ],
                      [Colors.grey, Colors.grey, Colors.grey],
                      buttonHeight,
                    ),

                    SizedBox(height: spacing),

                    _rowButtons(
                      ["Desvío Iz", "Desvío Dr"],
                      [Colors.teal, Colors.teal],
                      buttonHeight,
                    ),

                    SizedBox(height: spacing),

                    _rowButtons(
                      ["+Giro", "-Giro"],
                      [Colors.purple, Colors.purple],
                      buttonHeight,
                    ),

                    SizedBox(height: spacing),

                    _rowButtons(
                      ["+CM", "-CM"],
                      [Colors.brown, Colors.brown],
                      buttonHeight,
                    ),

                    SizedBox(height: spacing),

                    _rowButtons(
                      ["+Freno", "-Freno"],
                      [Colors.red, Colors.red],
                      buttonHeight,
                    ),
                  ],
                ),
              ),
      ],
    );

  }





  Widget _rowButtons(
    List<String> texts,
    List<Color> colors,
    List<String> data,
    double height,
  ) {
    return Row(
      children: List.generate(texts.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              height: height,
              child: ElevatedButton(
                onPressed: () {
                  BluetoothSender.sendData(connection, data[index]);
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
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        );
      }
      ),
    );
  }

  Widget _bigButton(String text, Color color, double height) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          debugPrint("$text presionado");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


