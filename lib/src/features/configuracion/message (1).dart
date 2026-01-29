import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const ControlScreen(),
    );
  }
}

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final buttonHeight = constraints.maxHeight * 0.065;
          final spacing = constraints.maxHeight * 0.015;

          return Stack(
            children: [
              // ===============================
              // IMAGEN DE FONDO (MISMAS CONSTRAINTS)
              // ===============================
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image.asset(
                  'assets/images/homeBg.webp',
                  fit: BoxFit.cover,
                ),
              ),

              // ===============================
              // CONTENIDO
              // ===============================
              SingleChildScrollView(
                padding: EdgeInsets.all(constraints.maxWidth * 0.04),
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
                        vertical: constraints.maxHeight * 0.03,
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
        },
      ),
    );
  }

  // ===============================
  // BOTÓN GRANDE
  // ===============================
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

  // ===============================
  // FILA DE BOTONES
  // ===============================
  Widget _rowButtons(
    List<String> texts,
    List<Color> colors,
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
                  debugPrint("${texts[index]} presionado");
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
      }),
    );
  }
}
