import '../classes/classes.dart';

class Levels {
  static const LevelData tutorial = LevelData(
  title: 'Tutorial',
  id: 'tutorial',
  objectiveDescription: 'Completa el tutorial arrastrando el bloque Sensor.',
  startRow: 9,
  startCol: 1,
  startDirection: 0, // norte
  winDirection: 0,   // Sur
  threeStarMaxBlocks: 4,
  twoStarMaxBlocks: 5,
  imagePath1: 'assets/imagenesNiveles/tutorial_1.png',
  imagePath2: 'assets/imagenesNiveles/tutorial_2.png',
  rawMap: [
    ['i','i','i','i','i','i','i','i','i','i','i'],
    ['i','2','0','1','0','1','0','1','0','1','i'],
    ['i','0','0','0','0','0','0','0','0','0','i'],
    ['i','1','0','1','0','1','0','1','0','1','i'],
    ['i','0','0','0','0','0','0','0','0','0','i'],
    ['i','1','0','1','0','1','0','1','0','1','i'],
    ['i','0','0','0','0','0','0','0','0','0','i'],
    ['i','1','0','1','0','1','0','1','0','1','i'],
    ['i','0','0','0','0','0','0','0','0','0','i'],
    ['i','1','0','1','0','1','0','1','0','1','i'],
    ['i','i','i','i','i','i','i','i','i','i','i'],
  ],
);

  static const LevelData level1 = LevelData(
    title: 'Nivel 1',
    id: 'nivel_1',
    objectiveDescription: 'Recoge el zumbador mirando hacia el Este.',
    startRow: 9,
    startCol: 1,
    startDirection: 0, // Norte
    winDirection: 1,   // Este  
    threeStarMaxBlocks: 6,
    twoStarMaxBlocks: 9,
    imagePath1: 'assets/imagenesNiveles/nivel1_1.png',
    imagePath2: 'assets/imagenesNiveles/nivel1_2.png',
    rawMap: [
    ['i','i','i','i','i','i','i','i','i','i','i'],
    ['i','1','0','1','0','1','0','1','0','2','i'],
    ['i','0','0','0','0','0','0','0','0','0','i'],
    ['i','1','0','1','0','0','0','1','0','1','i'],
    ['i','0','0','0','0','0','0','0','0','0','i'],
    ['i','1','0','1','0','1','0','1','0','1','i'],
    ['i','0','0','0','0','0','0','0','0','0','i'],
    ['i','1','0','1','0','1','0','1','0','1','i'],
    ['i','0','0','0','0','0','0','0','0','0','i'],
    ['i','1','0','1','0','1','0','1','0','1','i'],
    ['i','i','i','i','i','i','i','i','i','i','i'],
  ],
    availableBlocks: [
      ToolboxBlockConfig(name: 'Avanzar',   code: 'A'),
      ToolboxBlockConfig(name: 'Giro Der.', code: 'D'),
      ToolboxBlockConfig(name: 'Sensor',    code: 'S'),
      ToolboxBlockConfig(name: 'Repetir',   isLoop: true),
    ],
  );

  static const LevelData level2 = LevelData(
    title: 'Nivel 2',
    id: 'nivel_2',
    objectiveDescription:
        'Guía al Karelito hasta la meta usando bloques de código.',
    startRow: 7,
    startCol: 3,
    startDirection: 0, // Norte
    winDirection: 3,   // Oeste
    threeStarMaxBlocks: 6,
    twoStarMaxBlocks: 9,
    imagePath1: 'assets/imagenesNiveles/nivel2_1.png',
    imagePath2: 'assets/imagenesNiveles/nivel2_2.png',
    rawMap: [
      ['i','i','i','i','i','i','i','i','i','i','i'],
      ['i','1','0','1','0','1','0','1','0','1','i'],
      ['i','0','i','i','i','i','i','i','i','0','i'],
      ['i','1','i','1','0','1','0','1','i','1','i'],
      ['i','0','i','0','0','0','0','0','i','0','i'],
      ['i','1','i','1','0','1','0','1','i','1','i'],
      ['i','0','i','0','0','0','0','0','i','0','i'],
      ['i','1','i','1','0','2','0','1','i','1','i'],
      ['i','0','i','0','i','i','i','i','i','0','i'],
      ['i','1','0','1','0','1','0','1','0','1','i'],
      ['i','i','i','i','i','i','i','i','i','i','i'],
    ],
  );
static const LevelData level3 = LevelData(
    title: 'Nivel 3',
    id: 'nivel_3',
    objectiveDescription:
        'Guía al Karelito hasta la meta usando bloques de código.',
    startRow: 1,
    startCol: 1,
    startDirection: 0, // Norte
    winDirection: 1,   // este
    threeStarMaxBlocks: 11,
    twoStarMaxBlocks: 18,
    imagePath1: 'assets/imagenesNiveles/nivel3_1.png',
    imagePath2: 'assets/imagenesNiveles/nivel3_2.png',
    rawMap: [
['i','i','i','i','i','i','i','i','i','i','i'],
['i','1','0','1','0','1','0','1','i','i','i'],  // ← borde superior abierto →
['i','i','i','i','i','i','i','0','i','0','i'],  //                          ↓
['i','1','0','1','0','1','i','1','i','1','i'],  // ← segunda capa →         ↓
['i','0','i','i','i','0','i','0','i','0','i'],  // ↑                ↓       ↓
['i','1','i','2','0','1','i','1','i','1','i'],  // ↑  centro(sensor)↑       ↓
['i','0','i','i','i','i','i','0','i','0','i'],  // ↑         ↑      ↓       ↓
['i','1','0','1','0','1','0','1','i','1','i'],  // ↑  ← segunda capa        ↓
['i','i','i','i','i','i','i','i','i','0','i'],  // ↑                        ↓
['i','1','0','1','0','1','0','1','0','1','i'],  // ↑ ←  borde inferior      ↓
['i','i','i','i','i','i','i','i','i','i','i'],
    ],
  );
  static const LevelData level4 = LevelData(
    title: 'Nivel 4',
    id: 'nivel_4',
    objectiveDescription:
        'Guía al Karelito hasta la meta usando bloques de código.',
    startRow: 9,
    startCol: 1,
    startDirection: 2, // sur
    winDirection: 1,   // este
    threeStarMaxBlocks: 20,
    twoStarMaxBlocks: 24,
    imagePath1: 'assets/imagenesNiveles/nivel4_1.png',
    imagePath2: 'assets/imagenesNiveles/nivel4_2.png',
    rawMap: [
      ['i','i','i','i','i','i','i','i','i','i','i'],
      ['i','1','0','1','0','2','0','1','0','1','i'],
      ['i','i','i','i','i','i','i','i','i','0','i'],
      ['i','1','0','1','i','1','0','2','0','1','i'],
      ['i','0','i','i','i','i','i','i','i','0','i'],
      ['i','1','0','2','0','1','0','1','0','1','i'],
      ['i','0','i','i','i','0','i','i','i','0','i'],
      ['i','1','i','1','i','1','i','1','0','1','i'],
      ['i','0','i','0','i','0','i','0','0','0','i'],
      ['i','1','i','1','i','1','i','1','0','1','i'],
      ['i','i','i','i','i','i','i','i','i','i','i'],
    ],
  );
  static const LevelData level5 = LevelData(
    title: 'Nivel 5',
    id: 'nivel_5',
    objectiveDescription:
        'Guía al Karelito hasta la meta usando bloques de código.',
    startRow: 9,
    startCol: 1,
    startDirection: 0, // Norte
    winDirection: 1,   // este
    threeStarMaxBlocks: 26,
    twoStarMaxBlocks: 34,
    imagePath1: 'assets/imagenesNiveles/nivel5_1.png',
    imagePath2: 'assets/imagenesNiveles/nivel5_2.png',
    rawMap: [
      ['i','i','i','i','i','i','i','i','i','i','i'],
      ['i','2','0','1','0','1','0','1','0','1','i'],
      ['i','0','i','i','i','i','i','i','i','0','i'],
      ['i','1','i','2','0','1','0','1','0','1','i'],
      ['i','0','i','i','i','i','i','i','i','0','i'],
      ['i','1','0','1','0','1','0','1','i','1','i'],
      ['i','i','i','i','i','0','i','0','i','0','i'],
      ['i','1','0','1','i','2','i','2','i','1','i'],
      ['i','0','i','0','i','i','i','i','i','0','i'],
      ['i','1','i','1','0','1','0','1','0','1','i'],
      ['i','i','i','i','i','i','i','i','i','i','i'],
    ],
  );
  static List<LevelData> get all => [tutorial, level1, level2, level3, level4, level5];
}