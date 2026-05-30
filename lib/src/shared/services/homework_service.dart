import 'package:cloud_firestore/cloud_firestore.dart';
import 'services.dart';


class HomeworkService {
  static final _firestore = FirebaseFirestore.instance;

  /// Create homework assignment
  static Future<String> createHomework({
    required String classId,
    required String levelId,
    required String teacherId,
    required DateTime dueDate,
    required String description,
  }) async {
    try {
      // Generate unique ID
      final homeworkId = _firestore.collection('homeworks').doc().id;

      // THIS CREATES THE DOCUMENT IN FIRESTORE
      await _firestore.collection('homeworks').doc(homeworkId).set({
        'classId': classId,
        'levelId': levelId,
        'assignedBy': teacherId,
        'dueDate': Timestamp.fromDate(dueDate),
        'description': description,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      PopupService.success('Tarea Creada: $homeworkId');
      return homeworkId;
    } catch (e) {
      PopupService.error('Error al Crear la Tarea: $e');
      throw Exception('Failed to create homework: $e');
    }
  }
}