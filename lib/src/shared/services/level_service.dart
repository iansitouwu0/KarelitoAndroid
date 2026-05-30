import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:karelito/src/shared/services/popup_service.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class LevelService {
  static final _firestore = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;
  static const _uuid = Uuid();

  /// Create a new level document
  static Future<String> createLevel({
    required String creatorId,
    required LevelModel level,
  }) async {
    try {
      // Generate unique ID for the level
      final levelId = _uuid.v4();

      // Convert level to Firestore format
      final levelData = level.toFirestore();
      levelData['id'] = levelId; // Include ID in document

      // THIS CREATES THE DOCUMENT IN FIRESTORE
      await _firestore
          .collection('levels')
          .doc(levelId)
          .set(levelData);

      PopupService.success('Nivel Creado: $levelId');
      return levelId;
    } catch (e) {
      PopupService.error('Error Creando el Nivel: $e');
      throw Exception('Failed to create level: $e');
    }
  }
  // Update level
  static Future<void> updateLevel({
    required String levelId,
    required LevelModel level,
  }) async {
    try {
      await _firestore
          .collection('levels')
          .doc(levelId)
          .update(level.toFirestore());

      PopupService.success('Nivel Editado: $levelId');
    } catch (e) {
      PopupService.error('Error Editando el Nivel: $e');
      throw Exception('Fallo en Editar el Nivel: $e');
    }
  }

  // Obtener Nivel Por ID
  static Future<LevelModel?> getLevelById(String levelId) async {
    try {
      final doc = await _firestore.collection('levels').doc(levelId).get();
      if (!doc.exists) return null;
      return LevelModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get level: $e');
    }
  }

  // Obtener Niveles de Usuarios
  static Future<List<LevelModel>> getUserLevels(String userId) async {
    try {
      final query = await _firestore
          .collection('levels')
          .where('creatorId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => LevelModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user levels: $e');
    }
  }

  // Obtener Niveles Publicos
  static Future<List<LevelModel>> getPublicLevels({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _firestore
          .collection('levels')
          .where('visibility', isEqualTo: 'public')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final docs = await query.get();
      return docs.docs.map((doc) => LevelModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get public levels: $e');
    }
  }

  // Subir Imagen del Nivel
  static Future<String> uploadLevelImage({
    required String levelId,
    required String imagePath,
  }) async {
    try {
      final ref = _storage.ref('levels/$levelId/preview.jpg');
      await ref.putFile(File(imagePath));
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Borrar Nivel
  static Future<void> deleteLevel({
    required String levelId,
    required String creatorId,
  }) async {
    try {
      // Verificar que sea Propio
      final level = await getLevelById(levelId);
      if (level?.creatorId != creatorId) {
        throw Exception('You do not have permission to delete this level');
      }

      await _firestore.collection('levels').doc(levelId).delete();
    } catch (e) {
      throw Exception('Failed to delete level: $e');
    }
  }
}