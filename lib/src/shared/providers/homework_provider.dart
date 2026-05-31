import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Provider for managing homework state across the app
class HomeworkProvider extends ChangeNotifier {
  List<HomeworkModel> _classHomework = [];
  List<HomeworkModel> _studentHomework = [];
  HomeworkModel? _currentHomework;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<HomeworkModel> get classHomework => _classHomework;
  List<HomeworkModel> get studentHomework => _studentHomework;
  HomeworkModel? get currentHomework => _currentHomework;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load homework for a class
  Future<bool> loadClassHomework(String classId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _classHomework = await HomeworkService.getClassHomework(classId);
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

  /// Load homework for a student
  Future<bool> loadStudentHomework(String studentId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _studentHomework = await HomeworkService.getStudentHomework(studentId);
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

  /// Get a specific homework by ID
  Future<bool> getHomeworkById(String homeworkId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentHomework = await HomeworkService.getHomeworkById(homeworkId);
      _isLoading = false;
      notifyListeners();
      return _currentHomework != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Create homework
  Future<String?> createHomework({
    required String classId,
    required String levelId,
    required String teacherId,
    required DateTime dueDate,
    required String description,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final homeworkId = await HomeworkService.createHomework(
        classId: classId,
        levelId: levelId,
        assignedBy: teacherId,
        dueDate: dueDate,
        description: description,
      );

      // Reload class homework
      await loadClassHomework(classId);
      return homeworkId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Update homework
  Future<bool> updateHomework({
    required String homeworkId,
    required String classId,
    required DateTime dueDate,
    required String description,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await HomeworkService.updateHomework(
        homeworkId: homeworkId,
        dueDate: dueDate,
        description: description,
      );

      // Reload class homework
      await loadClassHomework(classId);
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

  /// Delete homework
  Future<bool> deleteHomework({
    required String homeworkId,
    required String classId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await HomeworkService.deleteHomework(homeworkId: homeworkId);

      _classHomework.removeWhere((h) => h.id == homeworkId);
      _studentHomework.removeWhere((h) => h.id == homeworkId);
      if (_currentHomework?.id == homeworkId) {
        _currentHomework = null;
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

  /// Submit homework solution
  Future<bool> submitSolution({
    required String homeworkId,
    required String studentId,
    required String solution,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await HomeworkService.submitSolution(
        homeworkId: homeworkId,
        studentId: studentId,
        solution: solution,
      );

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

  /// Get homework completion status
  Future<bool> getCompletionStatus({
    required String studentId,
    required String classId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final status = await HomeworkService.getCompletionStatus(
        studentId: studentId,
        classId: classId,
      );

      _isLoading = false;
      notifyListeners();
      return status;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear current homework
  void clearCurrentHomework() {
    _currentHomework = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}