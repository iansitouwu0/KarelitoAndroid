import 'package:flutter/material.dart';
import 'package:karelito/src/features/niveles/view/niveles_nivel.dart';
import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/views/views.dart';


class NivelesScreen extends StatelessWidget {
  const NivelesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NivelesProvider nivelesProvider= NivelesProvider();
    final List<Nivel> niveles = nivelesProvider.niveles;

    return Scaffold(
      body: LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('home/homeBg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 60,
            vertical: 12,
          ),
        child: SingleChildScrollView(
  child: Column(
    
    children: [
      SizedBox(height: height * 0.05),

      const TitleCard(text: 'NIVELES'),
      SizedBox(height: height * 0.04),
      LayoutBuilder(
        builder: (context, constraints) {
          
          return Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              
            VistaNiveles(niveles: niveles, constraints: constraints),
      const SizedBox(height: 40), 
            ],
        );})
    ],
  ),
),
      )

    );
    },
      ),
    );
  }

}
