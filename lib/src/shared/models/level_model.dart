import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum LevelDifficulty { easy, medium, hard }
enum LevelVisibility { public, private, classOnly }

class MapData extends Equatable {
  final int width;
  final int height;
  final List<List<String>> data;
  final int startRow;
  final int startCol;
  final int startDirection; // 0=N, 1=E, 2=S, 3=W
  final int winDirection;

  const MapData({
    required this.width,
    required this.height,
    required this.data,
    required this.startRow,
    required this.startCol,
    required this.startDirection,
    required this.winDirection,
  });

  factory MapData.fromMap(Map<String, dynamic> map) {
    return MapData(
      width: map['width'] ?? 7,
      height: map['height'] ?? 7,
      data: List<List<String>>.from(
        (map['data'] as List).map(
          (row) => List<String>.from(row as List),
        ),
      ),
      startRow: map['startRow'] ?? 1,
      startCol: map['startCol'] ?? 1,
      startDirection: map['startDirection'] ?? 0,
      winDirection: map['winDirection'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'width': width,
    'height': height,
    'data': data,
    'startRow': startRow,
    'startCol': startCol,
    'startDirection': startDirection,
    'winDirection': winDirection,
  };

  @override
  List<Object?> get props => [
    width, height, data, startRow, startCol, startDirection, winDirection
  ];
}

class LevelModel extends Equatable {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final LevelDifficulty difficulty;
  final MapData map;
  final int buzzers;
  final int threeStarMaxBlocks;
  final int twoStarMaxBlocks;
  final LevelVisibility visibility;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LevelModel({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.map,
    required this.buzzers,
    required this.threeStarMaxBlocks,
    required this.twoStarMaxBlocks,
    required this.visibility,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LevelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LevelModel(
      id: doc.id,
      creatorId: data['creatorId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      difficulty: LevelDifficulty.values.byName(data['difficulty'] ?? 'easy'),
      map: MapData.fromMap(data['map'] ?? {}),
      buzzers: data['buzzers'] ?? 0,
      threeStarMaxBlocks: data['threeStarMaxBlocks'] ?? 10,
      twoStarMaxBlocks: data['twoStarMaxBlocks'] ?? 15,
      visibility: LevelVisibility.values.byName(data['visibility'] ?? 'public'),
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'creatorId': creatorId,
      'title': title,
      'description': description,
      'difficulty': difficulty.name,
      'map': map.toMap(),
      'buzzers': buzzers,
      'threeStarMaxBlocks': threeStarMaxBlocks,
      'twoStarMaxBlocks': twoStarMaxBlocks,
      'visibility': visibility.name,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  @override
  List<Object?> get props => [
    id, creatorId, title, description, difficulty, map, buzzers,
    threeStarMaxBlocks, twoStarMaxBlocks, visibility, imageUrl,
    createdAt, updatedAt
  ];
}