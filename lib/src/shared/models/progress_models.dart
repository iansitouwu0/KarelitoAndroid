import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Model for tracking user progress on a specific level
class LevelProgressModel extends Equatable {
  final String userId;
  final String levelId;
  final int stars;      // 0-3
  final bool isCompleted;
  final int attempts;
  final String? bestSolution;
  final DateTime lastAttempted;
  final DateTime? completedAt;

  const LevelProgressModel({
    required this.userId,
    required this.levelId,
    required this.stars,
    required this.isCompleted,
    required this.attempts,
    this.bestSolution,
    required this.lastAttempted,
    this.completedAt,
  });

  factory LevelProgressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LevelProgressModel(
      userId: data['userId'] ?? '',
      levelId: doc.id,
      stars: data['stars'] ?? 0,
      isCompleted: data['isCompleted'] ?? false,
      attempts: data['attempts'] ?? 0,
      bestSolution: data['bestSolution'],
      lastAttempted: (data['lastAttempted'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'stars': stars,
      'isCompleted': isCompleted,
      'attempts': attempts,
      'bestSolution': bestSolution,
      'lastAttempted': Timestamp.fromDate(lastAttempted),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  @override
  List<Object?> get props => [
    userId,
    levelId,
    stars,
    isCompleted,
    attempts,
    bestSolution,
    lastAttempted,
    completedAt,
  ];
}

/// Global progress stats for a class
class GlobalProgress extends Equatable {
  final int homeworksCompleted;
  final double averageStars;
  final DateTime lastUpdated;

  const GlobalProgress({
    required this.homeworksCompleted,
    required this.averageStars,
    required this.lastUpdated,
  });

  factory GlobalProgress.fromFirestore(Map<String, dynamic> data) {
    return GlobalProgress(
      homeworksCompleted: data['homeworksCompleted'] ?? 0,
      averageStars: (data['averageStars'] ?? 0.0).toDouble(),
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'homeworksCompleted': homeworksCompleted,
      'averageStars': averageStars,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  @override
  List<Object?> get props => [homeworksCompleted, averageStars, lastUpdated];
}

/// Model for tracking student progress in a class
class ClassProgressModel extends Equatable {
  final String userId;
  final String classId;
  final DateTime joinedAt;
  final List<String> completedHomeworks;  // List of homework IDs
  final GlobalProgress globalProgress;

  const ClassProgressModel({
    required this.userId,
    required this.classId,
    required this.joinedAt,
    required this.completedHomeworks,
    required this.globalProgress,
  });

  factory ClassProgressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClassProgressModel(
      userId: data['userId'] ?? '',
      classId: doc.id,
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedHomeworks: List<String>.from(data['completedHomeworks'] ?? []),
      globalProgress: GlobalProgress.fromFirestore(data['globalProgress'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'completedHomeworks': completedHomeworks,
      'globalProgress': globalProgress.toFirestore(),
    };
  }

  @override
  List<Object?> get props => [
    userId,
    classId,
    joinedAt,
    completedHomeworks,
    globalProgress,
  ];
}