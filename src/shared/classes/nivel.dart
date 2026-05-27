typedef KarelDirection = int;

class LevelData {
  final String title;
  final String id;
  final String objectiveDescription;
  final List<List<String>> rawMap;
  final int startRow;
  final int startCol;
  final KarelDirection startDirection;
  final KarelDirection winDirection;
  final int threeStarMaxBlocks;
  final int twoStarMaxBlocks;
  final String imagePath1;
  final String imagePath2;

  final List<ToolboxBlockConfig>? availableBlocks;

  const LevelData({
    required this.title,
    required this.id,
    required this.objectiveDescription,
    required this.rawMap,
    required this.startRow,
    required this.startCol,
    required this.startDirection,
    required this.winDirection,
    required this.threeStarMaxBlocks,
    required this.twoStarMaxBlocks,
    required this.imagePath1,
    required this.imagePath2,
    this.availableBlocks,
  });
  int calculateStars(int totalBlocks) {
    if (totalBlocks <= threeStarMaxBlocks) return 3;
    if (totalBlocks <= twoStarMaxBlocks) return 2;
    return 1;
  }
}
class ToolboxBlockConfig {
  final String name;
  final String? code;
  final bool isLoop;
  final bool isFunction;

  const ToolboxBlockConfig({
    required this.name,
    this.code,
    this.isLoop = false,
    this.isFunction = false,
  });
}