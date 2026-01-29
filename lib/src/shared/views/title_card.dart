import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String text;

  const TitleCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: height * 0.5,
        height: height * 0.1, 
        child: Card(
          elevation: 8,
          color: const Color.fromARGB(255, 255, 240, 240),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: height * 0.05,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}