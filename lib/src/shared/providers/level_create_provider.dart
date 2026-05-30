import 'package:flutter/material.dart';
import '../../shared/models/models.dart';
import '../../shared/services/services.dart';

class LevelCreateProvider extends ChangeNotifier {
  String _title = '';
  String _description = '';
  int _mapWidth = 7;
  int _mapHeight = 7;
  int _startRow = 1;
  int _startCol = 1;
  int _startDirection = 0;
  int _winDirection = 0;
  int _buzzers = 1;
  int _threeStarMaxBlocks = 10;
  int _twoStarMaxBlocks = 15;
  LevelDifficulty _difficulty = LevelDifficulty.easy;
  LevelVisibility _visibility = LevelVisibility.public;
  bool _isLoading = false;
  String? _error;

  // Getters
  String get title => _title;
  String get description => _description;
  int get mapWidth => _mapWidth;
  int get mapHeight => _mapHeight;
  int get startRow => _startRow;
  int get startCol => _startCol;
  int get startDirection => _startDirection;
  int get winDirection => _winDirection;
  int get buzzers => _buzzers;
  int get threeStarMaxBlocks => _threeStarMaxBlocks;
  int get twoStarMaxBlocks => _twoStarMaxBlocks;
  LevelDifficulty get difficulty => _difficulty;
  LevelVisibility get visibility => _visibility;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Setters
  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setMapWidth(int value) {
    _mapWidth = value;
    notifyListeners();
  }

  void setMapHeight(int value) {
    _mapHeight = value;
    notifyListeners();
  }

  void setStartRow(int value) {
    _startRow = value;
    notifyListeners();
  }

  void setStartCol(int value) {
    _startCol = value;
    notifyListeners();
  }

  void setStartDirection(int value) {
    _startDirection = value;
    notifyListeners();
  }

  void setWinDirection(int value) {
    _winDirection = value;
    notifyListeners();
  }

  void setDifficulty(LevelDifficulty value) {
    _difficulty = value;
    notifyListeners();
  }

  void setVisibility(LevelVisibility value) {
    _visibility = value;
    notifyListeners();
  }

  void setThreeStarMaxBlocks(int value) {
    _threeStarMaxBlocks = value;
    notifyListeners();
  }

  void setTwoStarMaxBlocks(int value) {
    _twoStarMaxBlocks = value;
    notifyListeners();
  }

  // Crear Mapa Default
  List<List<String>> _createDefaultMap() {
    final map = List.generate(
      _mapHeight,
      (i) => List.generate(
        _mapWidth,
        (j) {
          if (i == 0 || i == _mapHeight - 1 || j == 0 || j == _mapWidth - 1) {
            return 'i'; // Pared
          }
          return '0'; //Vacio
        },
      ),
    );
    // Posicion de Inicio
    if (_startRow < _mapHeight && _startCol < _mapWidth) {
      map[_startRow][_startCol] = '2'; // ZUMBADOR
    }
    return map;
  }

  // Crear Nivel 
  Future<bool> createLevel({required String userId}) async {
  try {
    _isLoading = true;
    notifyListeners();

    // Create map data
    final mapData = MapData(
      width: _mapWidth,
      height: _mapHeight,
      data: _createDefaultMap(),
      startRow: _startRow,
      startCol: _startCol,
      startDirection: _startDirection,
      winDirection: _winDirection,
    );

    // Create level model
    final level = LevelModel(
      id: '', // Will be generated
      creatorId: userId,
      title: _title,
      description: _description,
      difficulty: _difficulty,
      map: mapData,
      buzzers: _buzzers,
      threeStarMaxBlocks: _threeStarMaxBlocks,
      twoStarMaxBlocks: _twoStarMaxBlocks,
      visibility: _visibility,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save to Firestore
    final levelId = await LevelService.createLevel(
      creatorId: userId,
      level: level,
    );

    debugPrint('✅ Level created successfully: $levelId');
    return true;
  } catch (e) {
    _error = e.toString();
    notifyListeners();
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}