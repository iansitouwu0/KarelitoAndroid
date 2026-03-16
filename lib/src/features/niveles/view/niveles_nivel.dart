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
    return constraints.isMobile
        ? Column(
            children: [
              for (final nivel in niveles) _buildLevelCard(context, nivel),
            ],
          )
        : Row(
            children: [
              for (final nivel in niveles)
                Flexible(child: _buildLevelCard(context, nivel)),
            ],
          );
  }

  Widget _buildLevelCard(BuildContext context, Nivel nivel) {
    final height = MediaQuery.of(context).size.height;
    final isLocked = nivel.locked;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Opacity(
        opacity: isLocked ? 0.55 : 1.0,
        child: Card(
          elevation: isLocked ? 2 : 10,
          color: const Color.fromARGB(255, 12, 0, 82),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isLocked
                ? () => _showLockedDialog(context)
                : () => context.go('/levelView/${nivel.id}'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nivel.title,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      if (isLocked)
                        const Icon(Icons.lock_rounded,
                            color: Colors.white54, size: 22)
                      else
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _imageBox(nivel.startImage, height * 0.12),
                            _imageBox(
                                'assets/levelView/levelArrow.png', 32),
                            _imageBox(nivel.endImage, height * 0.12),
                          ],
                        ),
                        if (isLocked)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(Icons.lock_rounded,
                                  color: Colors.white70, size: 36),
                            ),
                          ),
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

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2535),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_rounded, color: Colors.white54),
            SizedBox(width: 10),
            Text('Nivel bloqueado',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        content: const Text(
          'Completa el nivel anterior para desbloquear este.',
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido',
                style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  Widget _imageBox(String path, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(path, fit: BoxFit.contain),
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
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Image.asset(
            index < filledStars
                ? 'assets/imagenesNiveles/Estrella.png'
                : 'assets/imagenesNiveles/EstrellaVacia.png',
            height: 30,
            fit: BoxFit.contain,
          ),
        );
      }),
    );
  }
}
