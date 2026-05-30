import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ClassVisibility { public, private }

class ClassModel extends Equatable {
  final String id;
  final String teacherId;
  final String className;
  final String description;
  final ClassVisibility visibility;
  final String? joinCode; // Only for private classes
  final List<String> studentIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClassModel({
    required this.id,
    required this.teacherId,
    required this.className,
    required this.description,
    required this.visibility,
    this.joinCode,
    required this.studentIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClassModel(
      id: doc.id,
      teacherId: data['teacherId'] ?? '',
      className: data['className'] ?? '',
      description: data['description'] ?? '',
      visibility: ClassVisibility.values.byName(data['visibility'] ?? 'public'),
      joinCode: data['joinCode'],
      studentIds: List<String>.from(data['studentIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teacherId': teacherId,
      'className': className,
      'description': description,
      'visibility': visibility.name,
      'joinCode': joinCode,
      'studentIds': studentIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  bool get isPublic => visibility == ClassVisibility.public;
  bool get isPrivate => visibility == ClassVisibility.private;

  @override
  List<Object?> get props => [
    id, teacherId, className, description, visibility, joinCode,
    studentIds, createdAt, updatedAt
  ];
}