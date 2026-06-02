import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ClassVisibility { public, private }

/// NO ERRORS FOUND CHECKED

class ClassModel extends Equatable {
  //ids for recognition
  final String id;
  final String teacherId;
  //visible class name
  final String className;
  final String description;
  final ClassVisibility visibility;
  final String? joinCode; // only for private classes
  //ids of signed up students
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
      //id is required always
      id: doc.id,
      //may not have a teachers
      teacherId: data['teacherId'] ?? '',
      //can be null, it will not often be
      className: data['className'] ?? '',
      //sometimes will have sometimes not
      description: data['description'] ?? '',

      visibility: ClassVisibility.values.byName(data['visibility'] ?? 'public'),
      //join code for private classes
      joinCode: data['joinCode'],
      //all students ids
      studentIds: List<String>.from(data['studentIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
  //class model constructor for firestore translation
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
  //equatable library needs this part for comparation
  @override
  List<Object?> get props => [
    id, teacherId, className, description, visibility, joinCode,
    studentIds, createdAt, updatedAt
  ];
}