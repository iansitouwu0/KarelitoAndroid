import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'HomeScreen',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final levels = [
  {
    'title': 'TUTORIAL',
    'stars': 1,
    'left': 'assets/images/Karel1.webp',
    'right': 'assets/images/Karel2.webp',
  },
  {
    'title': 'NIVEL 1',
    'stars': 0,
    'left': 'assets/images/Karel1.webp',
    'right': 'assets/images/Karel2.webp',
  },
  {
    'title': 'NIVEL 2',
    'stars': 0,
    'left': 'assets/images/Karel1.webp',
    'right': 'assets/images/Karel2.webp',
  },
];
  @override

  

  Widget build(BuildContext context) {


    return Scaffold(
  body: LayoutBuilder(
    builder: (context, constraints) {
      final height = constraints.maxHeight;

      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homeBg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        
        child: SingleChildScrollView(
  child: Column(
    children: [
      SizedBox(height: height * 0.05),

      const TitleCard(text: 'NIVELES'),

      SizedBox(height: height * 0.04),

      Column(
        children: levels.map((level) {
          return BigCard(
            title: level['title'] as String,
            stars: level['stars'] as int,
            imageLeft: level['left'] as String,
            imageRight: level['right'] as String,
            onTap: () {
              print('Entraste a ${level['title']}');
            },
          );
        }).toList(),
      ),

      const SizedBox(height: 40), // margen inferior
    ],
  ),
),

      );
    },
  ),
);


  }
}
class BigCard extends StatelessWidget {
  final String title;
  final int stars;
  final String imageLeft;
  final String imageRight;
  final VoidCallback onTap;

  const BigCard({
    super.key,
    required this.title,
    required this.stars,
    required this.imageLeft,
    required this.imageRight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
      child: SizedBox(
        width: height * 0.75,
        child: Card(
          elevation: 10,
          color: const Color.fromARGB(255, 12, 0, 82),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      StarRating(filledStars: stars),
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
                        _TutorialImage(
                          imagePath: imageLeft,
                          height: height * 0.15,
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 36,
                          color: Colors.black87,
                        ),
                        _TutorialImage(
                          imagePath: imageRight,
                          height: height * 0.15,
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
}

class _TutorialImage extends StatelessWidget {
  final String imagePath;
  final double height;

  const _TutorialImage({
    required this.imagePath,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int filledStars; // cuántas estrellas llenas
  final int totalStars;  // total de estrellas

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
                ? 'assets/images/Estrella.png'
                : 'assets/images/EstrellaVacia.png',
            height: 35, 
            fit: BoxFit.contain,
          ),
        );
      }),
    );
  }
}


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