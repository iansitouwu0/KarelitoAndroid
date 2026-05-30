import '../classes/classes.dart';

class Levels {
  static const LevelData tutorial = LevelData(
    title: 'Tutorial',
    id: 'tutorial',
    objectiveDescription: 'Recoge el zumbador mirando hacia el norte.',
    startRow: 5,
    startCol: 1,
    startDirection: 0, // Norte
    winDirection: 0,   // Norte
    threeStarMaxBlocks: 2,
    twoStarMaxBlocks: 4,
    imagePath1: 'assets/imagenesNiveles/tutorial_1.png',
    imagePath2: 'assets/imagenesNiveles/tutorial_2.png',
    rawMap: [
      ['i','i','i','i','i','i','i'],
      ['i','2','0','1','0','1','i'],
      ['i','0','0','0','0','0','i'],
      ['i','1','0','1','0','1','i'],
      ['i','0','0','0','0','0','i'],
      ['i','1','0','1','0','1','i'],
      ['i','i','i','i','i','i','i'],
    ],
    availableBlocks: [
      ToolboxBlockConfig(name: 'Avanzar', code: 'A'),
      ToolboxBlockConfig(name: 'Giro Izq.', code: 'I'),
      ToolboxBlockConfig(name: 'Sensor', code: 'S'),
      ToolboxBlockConfig(name: 'Repetir', isLoop: true),
      ToolboxBlockConfig(name: 'Función', isFunction: true),

    ],
  );

  static const LevelData level1 = LevelData(
    title: 'Nivel 1',
    id: 'nivel_1',
    objectiveDescription: 'Recoge el zumbador mirando hacia el Este.',
    startRow: 5,
    startCol: 1,
    startDirection: 0, 
    winDirection: 3,  
    threeStarMaxBlocks: 10,
    twoStarMaxBlocks: 13,
    imagePath1: 'assets/imagenesNiveles/nivel1_1.png',
    imagePath2: 'assets/imagenesNiveles/nivel1_2.png',
    rawMap: [
      ['i','i','i','i','i','i','i'],
      ['i','1','0','1','0','1','i'],
      ['i','0','i','i','i','0','i'],
      ['i','1','i','2','0','1','i'],
      ['i','0','i','i','i','0','i'],
      ['i','1','0','1','0','1','i'],
      ['i','i','i','i','i','i','i'],
    ],
    availableBlocks: [
      ToolboxBlockConfig(name: 'Avanzar', code: 'A'),
      ToolboxBlockConfig(name: 'Giro Izq.', code: 'I'),
      ToolboxBlockConfig(name: 'Sensor', code: 'S'),
      ToolboxBlockConfig(name: 'Repetir', isLoop: true),
      ToolboxBlockConfig(name: 'Función', isFunction: true),
    ],
  );

  static const LevelData level2 = LevelData(
    title: 'Nivel 2',
    id: 'nivel_2',
    objectiveDescription:
        'Guía al Karelito hasta la meta usando bloques de código.',
    startRow: 5,
    startCol: 1,
    startDirection: 0, // Norte
    winDirection: 3,   // Oeste
    threeStarMaxBlocks: 10,
    twoStarMaxBlocks: 12 ,
    imagePath1: 'assets/imagenesNiveles/nivel2_1.png',
    imagePath2: 'assets/imagenesNiveles/nivel2_2.png',
    rawMap: [
      ['i','i','i','i','i','i','i'],
      ['i','1','0','1','0','1','i'],
      ['i','0','i','i','i','0','i'],
      ['i','1','i','1','i','1','i'],
      ['i','0','i','i','i','0','i'],
      ['i','1','i','2','0','1','i'],
      ['i','i','i','i','i','i','i'],
    ],
    availableBlocks: [
      ToolboxBlockConfig(name: 'Avanzar', code: 'A'),
      ToolboxBlockConfig(name: 'Giro Izq.', code: 'I'),
      ToolboxBlockConfig(name: 'Sensor', code: 'S'),
      ToolboxBlockConfig(name: 'Repetir', isLoop: true),
      ToolboxBlockConfig(name: 'Función', isFunction: true),
    ],
  );

  static List<LevelData> get all => [tutorial, level1, level2];
}