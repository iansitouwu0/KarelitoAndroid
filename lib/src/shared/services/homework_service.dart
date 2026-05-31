import 'package:cloud_firestore/cloud_firestore.dart';
import 'services.dart';
import '../models/models.dart';
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
  /// Get all homework for a specific class
static Future<List<HomeworkModel>> getClassHomework(String classId) async {
  try {
    final snapshot = await _firestore
        .collection('homeworks')
        .where('classId', isEqualTo: classId)
        .orderBy('dueDate', descending: false)
        .get();
 
    return snapshot.docs
        .map((doc) => HomeworkModel.fromFirestore(doc))
        .toList();
  } catch (e) {
    PopupService.error('❌ Error getting class homework: $e');
    throw Exception('Failed to get class homework: $e');
  }
}
 
/// Get all homework assigned to a student
static Future<List<HomeworkModel>> getStudentHomework(String studentId) async {
  try {
    // Get all classes student is in
    final classesSnapshot = await FirebaseFirestore.instance
        .collection('classes')
        .where('studentIds', arrayContains: studentId)
        .get();
 
    final classIds = classesSnapshot.docs.map((doc) => doc.id).toList();
 
    if (classIds.isEmpty) {
      return [];
    }
 
    // Get homework for all these classes
    final homeworkSnapshots = await Future.wait(
      classIds.map((classId) =>
          FirebaseFirestore.instance
              .collection('homeworks')
              .where('classId', isEqualTo: classId)
              .get()),
    );
 
    final homeworkList = <HomeworkModel>[];
    for (var snapshot in homeworkSnapshots) {
      homeworkList.addAll(
        snapshot.docs.map((doc) => HomeworkModel.fromFirestore(doc)),
      );
    }
 
    return homeworkList;
  } catch (e) {
    PopupService.error('❌ Error getting student homework: $e');
    throw Exception('Failed to get student homework: $e');
  }
}
 
/// Get a specific homework by ID
static Future<HomeworkModel?> getHomeworkById(String homeworkId) async {
  try {
    final doc = await _firestore.collection('homeworks').doc(homeworkId).get();
    if (!doc.exists) return null;
    return HomeworkModel.fromFirestore(doc);
  } catch (e) {
    PopupService.error('❌ Error getting homework: $e');
    throw Exception('Failed to get homework: $e');
  }
}
 
/// Update homework (teacher only)
static Future<void> updateHomework({
  required String homeworkId,
  required DateTime dueDate,
  required String description,
}) async {
  try {
    await _firestore.collection('homeworks').doc(homeworkId).update({
      'dueDate': Timestamp.fromDate(dueDate),
      'description': description,
      'updatedAt': Timestamp.now(),
    });
 
    PopupService.success('✅ Homework updated: $homeworkId');
  } catch (e) {
    PopupService.error('❌ Error updating homework: $e');
    throw Exception('Failed to update homework: $e');
  }
}
 
/// Delete homework (teacher only)
static Future<void> deleteHomework({
  required String homeworkId,
}) async {
  try {
    await _firestore.collection('homeworks').doc(homeworkId).delete();
    PopupService.success('✅ Homework deleted: $homeworkId');
  } catch (e) {
    PopupService.error('❌ Error deleting homework: $e');
    throw Exception('Failed to delete homework: $e');
  }
}
 
/// Student submits homework solution
static Future<void> submitSolution({
  required String homeworkId,
  required String studentId,
  required String solution,
}) async {
  try {
    // Store submission
    await _firestore
        .collection('homeworks')
        .doc(homeworkId)
        .collection('submissions')
        .doc(studentId)
        .set({
          'studentId': studentId,
          'solution': solution,
          'submittedAt': Timestamp.now(),
          'isCompleted': true,
        });
 
    PopupService.success('✅ Solution submitted for homework: $homeworkId');
  } catch (e) {
    PopupService.error('❌ Error submitting solution: $e');
    throw Exception('Failed to submit solution: $e');
  }
}
 
/// Get homework completion status for student in class
static Future<bool> getCompletionStatus({
  required String studentId,
  required String classId,
}) async {
  try {
    // Get all homework for this class
    final homeworkSnapshot = await _firestore
        .collection('homeworks')
        .where('classId', isEqualTo: classId)
        .get();
 
    if (homeworkSnapshot.docs.isEmpty) {
      return false;
    }
 
    // Check if student completed at least one
    for (var hwDoc in homeworkSnapshot.docs) {
      final submissionDoc = await hwDoc.reference
          .collection('submissions')
          .doc(studentId)
          .get();
 
      if (submissionDoc.exists && submissionDoc['isCompleted'] == true) {
        return true;
      }
    }
 
    return false;
  } catch (e) {
    PopupService.error('❌ Error getting completion status: $e');
    throw Exception('Failed to get completion status: $e');
  }
}
}