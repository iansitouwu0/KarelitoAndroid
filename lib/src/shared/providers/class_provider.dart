import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Provider for managing class state across the app
class ClassProvider extends ChangeNotifier {
  List<ClassModel> _teacherClasses = [];
  List<ClassModel> _studentClasses = [];
  List<ClassModel> _publicClasses = [];
  ClassModel? _currentClass;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ClassModel> get teacherClasses => _teacherClasses;
  List<ClassModel> get studentClasses => _studentClasses;
  List<ClassModel> get publicClasses => _publicClasses;
  ClassModel? get currentClass => _currentClass;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load classes for teacher
  Future<bool> loadTeacherClasses(String teacherId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _teacherClasses = await ClassService.getTeacherClasses(teacherId);
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

  /// Load classes for student
  Future<bool> loadStudentClasses(String studentId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _studentClasses = await ClassService.getStudentClasses(studentId);
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

  /// Load public classes
  Future<bool> loadPublicClasses() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _publicClasses = await ClassService.getPublicClasses();
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

  /// Get a specific class by ID
  Future<bool> getClassById(String classId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentClass = await ClassService.getClassById(classId);
      _isLoading = false;
      notifyListeners();
      return _currentClass != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Create a new class
  Future<String?> createClass({
    required String teacherId,
    required String className,
    required String description,
    required ClassVisibility visibility,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final classId = await ClassService.createClass(
        teacherId: teacherId,
        className: className,
        description: description,
        visibility: visibility,
      );

      // Reload teacher classes
      await loadTeacherClasses(teacherId);
      return classId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Join a class with code (student)
  Future<bool> joinClassWithCode({
    required String code,
    required String studentId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await ClassService.joinClassWithCode(
        code: code,
        studentId: studentId,
      );

      // Reload student classes
      await loadStudentClasses(studentId);
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

  /// Join a public class (student)
  Future<bool> joinPublicClass({
    required String classId,
    required String studentId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await ClassService.joinPublicClass(
        classId: classId,
        studentId: studentId,
      );

      // Reload student classes
      await loadStudentClasses(studentId);
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

  /// Leave a class (student)
  Future<bool> leaveClass({
    required String classId,
    required String studentId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await ClassService.leaveClass(
        classId: classId,
        studentId: studentId,
      );

      _studentClasses.removeWhere((c) => c.id == classId);
      if (_currentClass?.id == classId) {
        _currentClass = null;
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

  /// Delete a class (teacher only)
  Future<bool> deleteClass({
    required String classId,
    required String teacherId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await ClassService.deleteClass(
        classId: classId,
        teacherId: teacherId,
      );

      _teacherClasses.removeWhere((c) => c.id == classId);
      if (_currentClass?.id == classId) {
        _currentClass = null;
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

  /// Clear current class
  void clearCurrentClass() {
    _currentClass = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}