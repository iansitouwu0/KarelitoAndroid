import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Provider for managing level state across the app
class LevelProvider extends ChangeNotifier {
  List<LevelModel> _userLevels = [];
  List<LevelModel> _publicLevels = [];
  LevelModel? _currentLevel;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<LevelModel> get userLevels => _userLevels;
  List<LevelModel> get publicLevels => _publicLevels;
  LevelModel? get currentLevel => _currentLevel;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load user's created levels
  Future<bool> loadUserLevels(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _userLevels = await LevelService.getUserLevels(userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load public levels available for all users
  Future<bool> loadPublicLevels() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _publicLevels = await LevelService.getPublicLevels();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get a specific level by ID
  Future<bool> getLevelById(String levelId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentLevel = await LevelService.getLevelById(levelId);
      _isLoading = false;
      notifyListeners();
      return _currentLevel != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Create a new level
  Future<String?> createLevel({
    required String userId,
    required LevelModel level,
    String? imagePath,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final levelId = await LevelService.createLevel(
        creatorId: userId,
        level: level,
      );

      // Reload user levels
      await loadUserLevels(userId);
      return levelId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Update an existing level
  Future<bool> updateLevel({
    required String levelId,
    required LevelModel updatedLevel,
    String? imagePath,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await LevelService.updateLevel(
        levelId: levelId,
        level: updatedLevel,
      );

      _currentLevel = updatedLevel;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a level
  Future<bool> deleteLevel(String levelId, String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await LevelService.deleteLevel(levelId: levelId, creatorId: userId);

      _userLevels.removeWhere((level) => level.id == levelId);
      if (_currentLevel?.id == levelId) {
        _currentLevel = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear current level
  void clearCurrentLevel() {
    _currentLevel = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}