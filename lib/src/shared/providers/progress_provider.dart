import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../models/progress_models.dart';
import '../services/services.dart';

/// Provider for managing user progress across the app
class ProgressProvider extends ChangeNotifier {
  Map<String, LevelProgressModel> _levelProgress = {};
  Map<String, ClassProgressModel> _classProgress = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, LevelProgressModel> get levelProgress => _levelProgress;
  Map<String, ClassProgressModel> get classProgress => _classProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get progress for a specific level
  LevelProgressModel? getLevelProgress(String levelId) {
    return _levelProgress[levelId];
  }

  /// Get progress for a specific class
  ClassProgressModel? getClassProgress(String classId) {
    return _classProgress[classId];
  }

  /// Load level progress for user
  Future<bool> loadLevelProgress(String userId, String levelId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final progress = await ProgressService.getLevelProgress(
        userId: userId,
        levelId: levelId,
      );

      // Handle nullable return
      if (progress != null) {
        _levelProgress[levelId] = progress;
      } else {
        // Create default progress if doesn't exist
        final defaultProgress = LevelProgressModel(
          userId: userId,
          levelId: levelId,
          stars: 0,
          isCompleted: false,
          attempts: 0,
          bestSolution: null,
          lastAttempted: DateTime.now(),
          completedAt: null,
        );
        _levelProgress[levelId] = defaultProgress;
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

  /// Load all level progress for user
  Future<bool> loadAllLevelProgress(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final progressList = await ProgressService.getAllLevelProgress(userId);

      _levelProgress.clear();
      for (var progress in progressList) {
        _levelProgress[progress.levelId] = progress;
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

  /// Load class progress for student
  Future<bool> loadClassProgress(String userId, String classId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final progress = await ProgressService.getClassProgress(
        userId: userId,
        classId: classId,
      );

      // Handle nullable return
      if (progress != null) {
        _classProgress[classId] = progress;
      }

      _isLoading = false;
      notifyListeners();
      return progress != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load all class progress for student
  Future<bool> loadAllClassProgress(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final progressList = await ProgressService.getAllClassProgress(userId);

      _classProgress.clear();
      for (var progress in progressList) {
        _classProgress[progress.classId] = progress;
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

  /// Save level progress
  Future<bool> saveLevelProgress({
    required String userId,
    required String levelId,
    required int stars,
    required bool isCompleted,
    required int attempts,
    String? bestSolution,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await ProgressService.saveLevelProgress(
        userId: userId,
        levelId: levelId,
        stars: stars,
        isCompleted: isCompleted,
        attempts: attempts,
        bestSolution: bestSolution,
      );

      // Update local cache
      final progress = LevelProgressModel(
        userId: userId,
        levelId: levelId,
        stars: stars,
        isCompleted: isCompleted,
        attempts: attempts,
        bestSolution: bestSolution,
        lastAttempted: DateTime.now(),
        completedAt: isCompleted ? DateTime.now() : null,
      );

      _levelProgress[levelId] = progress;
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

  /// Save class progress
  Future<bool> saveClassProgress({
    required String userId,
    required String classId,
    required List<String> completedHomeworks,
    required double averageStars,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Create GlobalProgress object
      final globalProgress = GlobalProgress(
        homeworksCompleted: completedHomeworks.length,
        averageStars: averageStars,
        lastUpdated: DateTime.now(),
      );

      // Create ClassProgressModel
      final classProgress = ClassProgressModel(
        userId: userId,
        classId: classId,
        joinedAt: DateTime.now(),
        completedHomeworks: completedHomeworks,
        globalProgress: globalProgress,
      );

      // Save to service
      await ProgressService.saveClassProgress(
        userId: userId,
        classId: classId,
        completedHomeworks: completedHomeworks,
        averageStars: averageStars,
      );

      // Update local cache
      _classProgress[classId] = classProgress;
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

  /// Get overall stats for user
  Future<Map<String, dynamic>?> getUserStats(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await loadAllLevelProgress(userId);
      await loadAllClassProgress(userId);

      // Calculate stats from level progress
      int totalLevels = _levelProgress.length;
      int completedLevels = _levelProgress.values
          .where((p) => p.isCompleted)
          .length;
      double averageStars = _levelProgress.isEmpty
          ? 0
          : _levelProgress.values
                  .fold<int>(0, (sum, p) => sum + p.stars) /
              _levelProgress.length;

      // Calculate stats from class progress
      int totalClasses = _classProgress.length;
      int totalCompletedHomeworks = 0;
      for (var progress in _classProgress.values) {
        totalCompletedHomeworks += progress.completedHomeworks.length;
      }

      _isLoading = false;
      notifyListeners();

      return {
        'totalLevels': totalLevels,
        'completedLevels': completedLevels,
        'averageStars': averageStars,
        'totalClasses': totalClasses,
        'completedHomeworks': totalCompletedHomeworks,
      };
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Clear specific level progress from cache
  void clearLevelProgress(String levelId) {
    _levelProgress.remove(levelId);
    notifyListeners();
  }

  /// Clear specific class progress from cache
  void clearClassProgress(String classId) {
    _classProgress.remove(classId);
    notifyListeners();
  }

  /// Clear all progress
  void clearAllProgress() {
    _levelProgress.clear();
    _classProgress.clear();
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}