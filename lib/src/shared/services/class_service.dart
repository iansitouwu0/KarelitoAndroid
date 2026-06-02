import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/class_model.dart';
import '../services/services.dart';

String generateAlphanumeric(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rnd = Random();
  
  return String.fromCharCodes(
    Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
  );
}

class ClassService {
  static final _firestore = FirebaseFirestore.instance;

  /// crear nueva clase
  static Future<String> createClass({
    required String teacherId,
    required String className,
    required String description,
    required ClassVisibility visibility,
  }) async {
    try {
      // Generate unique ID
      final classId = _firestore.collection('classes').doc().id;

      // Generate join code only for private classes
      final joinCode = visibility == ClassVisibility.private
          ? generateAlphanumeric(6) // 6-character random code
          : null;

      // THIS CREATES THE DOCUMENT IN FIRESTORE
      await _firestore.collection('classes').doc(classId).set({
        'teacherId': teacherId,
        'className': className,
        'description': description,
        'visibility': visibility.name,
        'joinCode': joinCode,
        'studentIds': [], // Empty initially
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      PopupService.success(
        'Clase Creada Exitosamente',
      );
      if (joinCode != null) {
        PopupService.success(
        'Codigo de Acceso: $joinCode',
      );
      }

      return classId;
    } catch (e) {
      PopupService.error('Fallo al Crear la Clase');
      throw Exception('Failed to create class: $e');
    }
  }

  /// Student joins a class with code (private)
  static Future<bool> joinClassWithCode({
    required String code,
    required String studentId,
  }) async {
    try {
      // Find class with this join code
      final query = await _firestore
          .collection('classes')
          .where('joinCode', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('Invalid join code');
      }

      final classDoc = query.docs.first;
      final classModel = ClassModel.fromFirestore(classDoc);

      // Check if already joined
      if (classModel.studentIds.contains(studentId)) {
        PopupService.warning('Ya Estas en Esta Clase');
        throw Exception('Already joined this class');
      }

      // Add student to class
      await _firestore
          .collection('classes')
          .doc(classDoc.id)
          .update({
        'studentIds': FieldValue.arrayUnion([studentId]),
        'updatedAt': Timestamp.now(),
      });

      // Create progress document for this student in this class
      await _createClassProgress(studentId, classDoc.id);

      PopupService.success(
        'El Alumno se Unio a La Clase: ${classDoc.id}',
      );
      return true;
    } catch (e) {
      PopupService.error('Error al Unirse a la Clase');
      throw Exception('Failed to join class: $e');
    }
  }

  /// Create class progress document for student
  static Future<void> _createClassProgress(
    String studentId,
    String classId,
  ) async {
    try {
      await _firestore
          .collection('classProgress')
          .doc(studentId)
          .collection(classId)
          .doc('_metadata')
          .set({
        'joinedAt': Timestamp.now(),
        'completedHomeworks': [],
        'globalProgress': {
          'homeworksCompleted': 0,
          'averageStars': 0.0,
          'lastUpdated': Timestamp.now(),
        },
      });

      PopupService.success('Progreso Creado Para el Estudiante: $studentId en la Clase $classId');

    } catch (e) {
      PopupService.error('Error Creando Progreso de Clase: $e');
    }
  }

 

  // Get teacher's classes
  static Future<List<ClassModel>> getTeacherClasses(String teacherId) async {
    try {
      final query = await _firestore
          .collection('classes')
          .where('teacherId', isEqualTo: teacherId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) => ClassModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get teacher classes: $e');
    }
  }

  // Get student's classes
  static Future<List<ClassModel>> getStudentClasses(String studentId) async {
    try {
      final query = await _firestore
          .collection('classes')
          .where('studentIds', arrayContains: studentId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) => ClassModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get student classes: $e');
    }
  }

  
  // Join public class
  static Future<bool> joinPublicClass({
    required String classId,
    required String studentId,
  }) async {
    try {
      final classDoc =
          await _firestore.collection('classes').doc(classId).get();

      if (!classDoc.exists) {
        PopupService.error('La Clase no Fue Encontrada');
        throw Exception('Class not found');
      }

      final classModel = ClassModel.fromFirestore(classDoc);

      if (!classModel.isPublic) {
        PopupService.warning('Esta Clase es Privada');

        throw Exception('This class is private');
      }

      if (classModel.studentIds.contains(studentId)) {
        PopupService.warning('Ya Estas en Esta Clase');
        throw Exception('Already joined this class');
      }

      await _firestore.collection('classes').doc(classId).update({
        'studentIds': FieldValue.arrayUnion([studentId]),
        'updatedAt': Timestamp.now(),
      });

      return true;
    } catch (e) {
      throw Exception('Failed to join class: $e');
    }
  }

  // Get class details
  static Future<ClassModel?> getClassById(String classId) async {
    try {
      final doc = await _firestore.collection('classes').doc(classId).get();
      if (!doc.exists) return null;
      return ClassModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get class: $e');
    }
  }

  // Update class
  static Future<void> updateClass({
    required String classId,
    required String className,
    required String description,
  }) async {
    try {
      await _firestore.collection('classes').doc(classId).update({
        'className': className,
        'description': description,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update class: $e');
    }
  }
static Future<List<ClassModel>> getPublicClasses() async {
  try {
    final snapshot = await _firestore
        .collection('classes')
        .where('visibility', isEqualTo: 'public')
        .get();
 
    return snapshot.docs
        .map((doc) => ClassModel.fromFirestore(doc))
        .toList();
  } catch (e) {
    PopupService.error('Error al Obtener las Clases Publicas: $e');
    throw Exception('Failed to get public classes: $e');
  }
}
 
/// Student leaves a class
static Future<void> leaveClass({
  required String classId,
  required String studentId,
}) async {
  try {
    await _firestore.collection('classes').doc(classId).update({
      'studentIds': FieldValue.arrayRemove([studentId]),
    });
 
    PopupService.success('Saliste de la Clase Exitosamente: $classId');
  } catch (e) {
    PopupService.error('Error al Salir de la Clase: $e');
    throw Exception('Failed to leave class: $e');
  }
}
 

 
/// Delete a class (teacher only)
static Future<void> deleteClass({
  required String classId,
  required String teacherId,
}) async {
  try {
    // Verify ownership
    final doc = await _firestore.collection('classes').doc(classId).get();
    if (!doc.exists) {
      throw Exception('Class not found');
    }
 
    final classData = ClassModel.fromFirestore(doc);
    if (classData.teacherId != teacherId) {
      throw Exception('You do not have permission to delete this class');
    }
 
    // Delete class
    await _firestore.collection('classes').doc(classId).delete();
    PopupService.success('Clase Eliminada: $classId');
  } catch (e) {
    PopupService.error('Error Eliminando Clase: $e');
    throw Exception('Failed to delete class: $e');
  }
}
}