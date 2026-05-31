import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karelito/src/shared/services/popup_service.dart';

import '../models/progress_models.dart';

class ProgressService {
  static final _firestore = FirebaseFirestore.instance;

  /// Get user's level progress
  static Future<Map<String, dynamic>?> getLevelProgress({
    required String userId,
    required String levelId,
  }) async {
    try {
      final doc = await _firestore
          .collection('levelProgress')
          .doc(userId)
          .collection('levels')
          .doc(levelId)
          .get();

      if (!doc.exists) return null;

      return doc.data();
    } catch (e) {
      PopupService.error('Error Obteniendo el Progreso del Nivel : $e');
      return null;
    }
  }

  /// Get all level progress for a user
  static Future<List<LevelProgressModel>> getAllLevelProgress(
    String userId,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('levelProgress')
          .doc(userId)
          .collection('levels')
          .get();

      return snapshot.docs
          .map((doc) => LevelProgressModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      PopupService.error('❌ Error getting all level progress: $e');
      throw Exception('Failed to get all level progress: $e');
    }
  }

  /// Get class progress for a student
  static Future<ClassProgressModel?> getClassProgress({
    required String userId,
    required String classId,
  }) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('classProgress')
          .doc(userId)
          .collection('classes')
          .doc(classId)
          .get();

      if (!doc.exists) return null;
      return ClassProgressModel.fromFirestore(doc);
    } catch (e) {
      PopupService.error('❌ Error getting class progress: $e');
      throw Exception('Failed to get class progress: $e');
    }
  }

  /// Get all class progress for a student
  static Future<List<ClassProgressModel>> getAllClassProgress(
    String userId,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('classProgress')
          .doc(userId)
          .collection('classes')
          .get();

      return snapshot.docs
          .map((doc) => ClassProgressModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      PopupService.error('❌ Error getting all class progress: $e');
      throw Exception('Failed to get all class progress: $e');
    }
  }

  /// Save class progress for a student
  static Future<void> saveClassProgress({
    required String userId,
    required String classId,
    required List<String> completedHomeworks,
    required double averageStars,
  }) async {
    try {
      final globalProgress = GlobalProgress(
        homeworksCompleted: completedHomeworks.length,
        averageStars: averageStars,
        lastUpdated: DateTime.now(),
      );

      final classProgress = ClassProgressModel(
        userId: userId,
        classId: classId,
        joinedAt: DateTime.now(),
        completedHomeworks: completedHomeworks,
        globalProgress: globalProgress,
      );

      await FirebaseFirestore.instance
          .collection('classProgress')
          .doc(userId)
          .collection('classes')
          .doc(classId)
          .set(classProgress.toFirestore());

      PopupService.success('✅ Class progress saved for user: $userId');
    } catch (e) {
      PopupService.error('❌ Error saving class progress: $e');
      throw Exception('Failed to save class progress: $e');
    }
  }

  /// Save or update level progress
  static Future<void> saveLevelProgress({
    required String userId,
    required String levelId,
    required int stars,
    required bool isCompleted,
    required int attempts,
    String? bestSolution,
  }) async {
    try {
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

      await FirebaseFirestore.instance
          .collection('levelProgress')
          .doc(userId)
          .collection('levels')
          .doc(levelId)
          .set(progress.toFirestore());

      PopupService.success('✅ Level progress saved: $levelId');
    } catch (e) {
      PopupService.error('❌ Error saving level progress: $e');
      throw Exception('Failed to save level progress: $e');
    }
  }
}
