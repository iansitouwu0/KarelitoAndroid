import 'package:flutter/material.dart';
import '../../../shared/views/views.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
 
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AdaptativeScreen(
      backgroundImage: '../assets/home/homeBg.jpg',

      titleImage: '../assets/home/homeTitle.png',
      height :height,
      children: [
                      SizedBox(
              width: height * 0.45,
              child: ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.04,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(
                    fontSize: height * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Jugar'),
              ),
            ),
            const Spacer(), 

        ],
    );
  }
}