import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karelito/src/shared/services/popup_service.dart';
import '../widgets/widgets.dart';

class ProgressService {
  static final _firestore = FirebaseFirestore.instance;

  /// Save level progress when student completes level
  static Future<void> saveLevelProgress({
    required String userId,
    required String levelId,
    required int stars, // 0-3
    required bool isCompleted,
    required int attempts,
    required String bestSolution,
  }) async {
    try {
      // Create or update level progress
      await _firestore
          .collection('levelProgress')
          .doc(userId)
          .collection('levels')
          .doc(levelId)
          .set({
        'stars': stars,
        'isCompleted': isCompleted,
        'attempts': attempts,
        'bestSolution': bestSolution,
        'lastAttempted': Timestamp.now(),
        'completedAt': isCompleted ? Timestamp.now() : null,
      }, SetOptions(merge: true));

      PopupService.success('Progreso Guardado, Nivel: $levelId Para el Usuario$userId');
    } catch (e) {
      PopupService.error('Error al Guardar Progreso: $e');
      throw Exception('Failed to save progress: $e');
    }
  }

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

  /// Get all user's levels progress
  static Future<List<Map<String, dynamic>>> getAllLevelProgress(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('levelProgress')
          .doc(userId)
          .collection('levels')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      PopupService.error('Error Obteniendo Todo el Progreso: $e');
      return [];
    }
  }
}