
import 'package:collection/collection.dart';
import '../classes/classes.dart';

class NivelesProvider {
  static NivelesProvider get shared => NivelesProvider();

  List<Nivel> get niveles => const [
    Nivel(
      id: 'tutorial',
      startImage: 'imagenesNiveles/tutorial_1.png',
      endImage: 'imagenesNiveles/tutorial_2.png',
      title: 'Tutorial',
    ),
    Nivel(
      id: 'nivel_1',
      startImage: 'imagenesNiveles/nivel1_1.png',
      endImage: 'imagenesNiveles/nivel1_2.png',
      title: 'Nivel 1'
    ),
    Nivel(
      id: 'nivel_2',
      startImage: 'imagenesNiveles/nivel2_1.png',
      endImage: 'imagenesNiveles/nivel2_2.png',
      title: 'Nivel 2'
    ),

  ];

  Nivel? getNivel(String id) {
    return niveles.firstWhereOrNull((nivel) => nivel.id == id);
  }
}
