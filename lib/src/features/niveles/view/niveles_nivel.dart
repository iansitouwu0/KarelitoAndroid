

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/extensions.dart';
  
class VistaNiveles extends StatelessWidget {
  const VistaNiveles({
    super.key,
    required this.niveles,
    required this.constraints,
  });

  final List<Nivel> niveles;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: constraints.isMobile
          ? Column(
              children: [
                for (final nivel in niveles) buildLevelCard(context, nivel)
              ],
            )
          : Row(
              children: [
                for (final nivel in niveles)
                  Flexible(flex:1, child: buildLevelCard(context, nivel)),
              ],
            ),
    );
  }

  Widget buildLevelCard(BuildContext context,Nivel nivel) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      
      child: SizedBox(
        width:  height * 0.75,
        
        child: Card(
          elevation:10,
          color: const Color.fromARGB(255, 12, 0, 82),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => GoRouter.of(context).go('/niveles/${nivel.id}'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        nivel.title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      StarRating(filledStars: nivel.stars),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 145, 147, 255),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _imageBox(nivel.startImage, height * 0.15),
                        _imageBox('levelView/levelArrow.png', 36),
                        _imageBox(nivel.endImage, height * 0.15),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

  
  Widget _imageBox(String path, double height) {
    return Container(
      width: height,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
class StarRating extends StatelessWidget {
  final int filledStars; 
  final int totalStars; 

  const StarRating({
    super.key,
    required this.filledStars,
    this.totalStars = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalStars, (index) {
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Image.asset(
            index < filledStars
                ? 'imagenesNiveles/Estrella.png'
                : 'imagenesNiveles/EstrellaVacia.png',
            height: 35,
            fit: BoxFit.contain,
          ),
        );
      }),
    );
  }
}
