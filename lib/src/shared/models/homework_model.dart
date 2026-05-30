import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HomeworkModel extends Equatable {
  final String id;
  final String classId;
  final String levelId;
  final String assignedBy; // teacherId
  final DateTime dueDate;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HomeworkModel({
    required this.id,
    required this.classId,
    required this.levelId,
    required this.assignedBy,
    required this.dueDate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HomeworkModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HomeworkModel(
      id: doc.id,
      classId: data['classId'] ?? '',
      levelId: data['levelId'] ?? '',
      assignedBy: data['assignedBy'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'classId': classId,
      'levelId': levelId,
      'assignedBy': assignedBy,
      'dueDate': Timestamp.fromDate(dueDate),
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  bool get isOverdue => DateTime.now().isAfter(dueDate);

  @override
  List<Object?> get props => [
    id, classId, levelId, assignedBy, dueDate, description,
    createdAt, updatedAt
  ];
}