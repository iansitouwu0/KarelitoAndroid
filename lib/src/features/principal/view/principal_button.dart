
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';


class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key
  });
  


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context , constraints ){
        return ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.04,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(
                    fontSize: constraints.maxHeight * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Jugar'),
              );
      }
      
      );
  }

}

