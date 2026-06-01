import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/progress_models.dart';
import 'popup_service.dart';

class ProgressService {
  static final _firestore = FirebaseFirestore.instance;

  /// Get level progress for a specific level - RETURNS NULL IF NOT FOUND
  static Future<LevelProgressModel?> getLevelProgress({
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

      return LevelProgressModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('❌ Error getting level progress: $e');
      PopupService.error('Error Obteniendo el Progreso del Nivel : $e');
      return null;
    }
  }

  /// Get all level progress for a user
  static Future<List<LevelProgressModel>> getAllLevelProgress(
      String userId) async {
    try {
      final snapshot = await _firestore
          .collection('levelProgress')
          .doc(userId)
          .collection('levels')
          .get();

      return snapshot.docs
          .map((doc) => LevelProgressModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting all level progress: $e');
      PopupService.error('Error Obteniendo Todo el Progreso: $e');
      return [];
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

      await _firestore
          .collection('levelProgress')
          .doc(userId)
          .collection('levels')
          .doc(levelId)
          .set(progress.toFirestore());

      debugPrint('✅ Level progress saved: $levelId');
      PopupService.success(
          'Progreso Guardado, Nivel: $levelId Para el Usuario: $userId');
    } catch (e) {
      debugPrint('❌ Error saving level progress: $e');
      PopupService.error('Error al Guardar Progreso: $e');
      throw Exception('Failed to save level progress: $e');
    }
  }

  /// Get class progress for a student - RETURNS NULL IF NOT FOUND
  static Future<ClassProgressModel?> getClassProgress({
    required String userId,
    required String classId,
  }) async {
    try {
      final doc = await _firestore
          .collection('classProgress')
          .doc(userId)
          .collection('classes')
          .doc(classId)
          .get();

      if (!doc.exists) return null;

      return ClassProgressModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('❌ Error getting class progress: $e');
      PopupService.error('Error Obteniendo Progreso de Clase: $e');
      return null;
    }
  }

  /// Get all class progress for a student
  static Future<List<ClassProgressModel>> getAllClassProgress(
      String userId) async {
    try {
      final snapshot = await _firestore
          .collection('classProgress')
          .doc(userId)
          .collection('classes')
          .get();

      return snapshot.docs
          .map((doc) => ClassProgressModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting all class progress: $e');
      PopupService.error('Error Obteniendo Progreso de Clases: $e');
      return [];
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

      await _firestore
          .collection('classProgress')
          .doc(userId)
          .collection('classes')
          .doc(classId)
          .set(classProgress.toFirestore());

      debugPrint('✅ Class progress saved for user: $userId');
      PopupService.success(
          'Progreso de Clase Guardado para Usuario: $userId');
    } catch (e) {
      debugPrint('❌ Error saving class progress: $e');
      PopupService.error('Error al Guardar Progreso de Clase: $e');
      throw Exception('Failed to save class progress: $e');
    }
  }
}