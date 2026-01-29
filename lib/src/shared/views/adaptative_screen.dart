import 'package:flutter/material.dart';

class AdaptativeScreen extends StatelessWidget{
  final String backgroundImage;
  final String titleImage;
  final List<Widget> children;
  final double height;

  const AdaptativeScreen ({
    super.key,
    required this.children,
    required this.backgroundImage,
    required this.titleImage,
    required this.height
  });

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
      builder: (context, constraints) {

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
                Column(
                  children: [
                    SizedBox(height: height * 0.05), 
                    Image.asset(
                      titleImage,
                      width: height * 0.8, 
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: height * 0.12),
                  ],
                ),              
                Expanded(
                  child:Column(
                    children: children,
                  ),
                ),
              ]
            ),
          );
        }
      ),
    );
  } 
}