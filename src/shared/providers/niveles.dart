
import 'package:collection/collection.dart';
import '../classes/classes.dart';

class NivelesProvider {
  static NivelesProvider get shared => NivelesProvider();

  List<Nivel> get niveles => const [
    Nivel(
      id: 'tutorial',
      startImage: 'assets/imagenesNiveles/tutorial_1.png',
      endImage: 'assets/imagenesNiveles/tutorial_2.png',
      title: 'Tutorial',
    ),
    Nivel(
      id: 'nivel_1',
      startImage: 'assets/imagenesNiveles/nivel1_1.png',
      endImage: 'assets/imagenesNiveles/nivel1_2.png',
      title: 'Nivel 1'
    ),
    Nivel(
      id: 'nivel_2',
      startImage: 'assets/imagenesNiveles/nivel2_1.png',
      endImage: 'assets/imagenesNiveles/nivel2_2.png',
      title: 'Nivel 2'
    ),
    Nivel(
      id: 'nivel_3',
      startImage: 'assets/imagenesNiveles/nivel3_1.png',
      endImage: 'assets/imagenesNiveles/nivel3_2.png',
      title: 'Nivel 3'
),
 Nivel(
      id: 'nivel_4',
      startImage: 'assets/imagenesNiveles/nivel4_1.png',
      endImage: 'assets/imagenesNiveles/nivel4_2.png',
      title: 'Nivel 4'
    ),
    Nivel(
      id: 'nivel_5',
      startImage: 'assets/imagenesNiveles/nivel5_1.png',
      endImage: 'assets/imagenesNiveles/nivel5_2.png',
      title: 'Nivel 5'
    ),
  ];

  Nivel? getNivel(String id) {
    return niveles.firstWhereOrNull((nivel) => nivel.id == id);
  }
}
