import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager extends ChangeNotifier {
  static final ProgressManager _instance = ProgressManager._internal();
  factory ProgressManager() => _instance;
  ProgressManager._internal();

  static const String _starsPrefix = 'stars_';
  static const String _blocksPrefix = 'blocks_';
  static const String _runsPrefix = 'runs_';
  static const String _blockTypesPrefix = 'blocktypes_';
  static const String _blockTypeUsagePrefix = 'blocktypeusage_';
  static const String _collisionPrefix = 'collisions_';
  static const String _nonCompletionPrefix = 'failures_';
  static const String _bestTimePrefix = 'besttime_';
  static const String _scorePrefix = 'score_';
  static const String _unlockedPrefix = 'unlocked_';

  // IDs de niveles en orden
  static const List<String> levelOrder = ['tutorial', 'nivel_1', 'nivel_2', 'nivel_3', 'nivel_4', 'nivel_5'];

  SharedPreferences? _prefs;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    _prefs = await SharedPreferences.getInstance();
    _loaded = true;
    await _unlock('tutorial');
  }

  int getStars(String levelId) {
    return _prefs?.getInt('$_starsPrefix$levelId') ?? 0;
  }

  int getBestBlocks(String levelId) {
    return _prefs?.getInt('$_blocksPrefix$levelId') ?? 0;
  }

  Future<void> saveStars(String levelId, int stars) async {
    final current = getStars(levelId);
    if (stars <= current) return; // solo guardamos si mejora
    await _prefs?.setInt('$_starsPrefix$levelId', stars);
    notifyListeners();
  }

  Future<void> saveBestBlocks(String levelId, int blocks) async {
    final current = getBestBlocks(levelId);
    if (current != 0 && blocks >= current) return;
    await _prefs?.setInt('$_blocksPrefix$levelId', blocks);
    notifyListeners();
  }

  int getRunAttempts(String levelId) {
    return _prefs?.getInt('$_runsPrefix$levelId') ?? 0;
  }

  int get totalRunAttempts {
    return levelOrder.fold(0, (sum, id) => sum + getRunAttempts(id));
  }

  Future<void> incrementRunAttempts(String levelId) async {
    final current = getRunAttempts(levelId);
    await _prefs?.setInt('$_runsPrefix$levelId', current + 1);
    notifyListeners();
  }

  int getCollisionAttempts(String levelId) {
    return _prefs?.getInt('$_collisionPrefix$levelId') ?? 0;
  }

  int get totalCollisionAttempts {
    return levelOrder.fold(0, (sum, id) => sum + getCollisionAttempts(id));
  }

  Future<void> incrementCollisionAttempts(String levelId) async {
    final current = getCollisionAttempts(levelId);
    await _prefs?.setInt('$_collisionPrefix$levelId', current + 1);
    notifyListeners();
  }

  int getNonCompletionAttempts(String levelId) {
    return _prefs?.getInt('$_nonCompletionPrefix$levelId') ?? 0;
  }

  int get totalNonCompletionAttempts {
    return levelOrder.fold(0, (sum, id) => sum + getNonCompletionAttempts(id));
  }

  Future<void> incrementNonCompletionAttempts(String levelId) async {
    final current = getNonCompletionAttempts(levelId);
    await _prefs?.setInt('$_nonCompletionPrefix$levelId', current + 1);
    notifyListeners();
  }

  Map<String, int> getBlockTypeCounts(String levelId) {
    final defaults = {
      'Avanzar': 0,
      'Giro Izq.': 0,
      'Giro Der.': 0,
      'Sensor': 0,
      'Repetir': 0,
      'Función': 0,
    };

    final raw = _prefs?.getString('$_blockTypeUsagePrefix$levelId');
    if (raw == null || raw.isEmpty) return defaults;
    try {
      final decoded = json.decode(raw);
      final counts = Map<String, int>.from(decoded);
      return {
        ...defaults,
        ...counts,
      };
    } catch (_) {
      return defaults;
    }
  }

  Future<void> incrementBlockTypeUsage(String levelId, Map<String, int> blockTypes) async {
    final currentCounts = getBlockTypeCounts(levelId);
    final updatedCounts = Map<String, int>.from(currentCounts);

    blockTypes.forEach((key, value) {
      updatedCounts[key] = (updatedCounts[key] ?? 0) + value;
    });

    await _prefs?.setString('$_blockTypeUsagePrefix$levelId', json.encode(updatedCounts));
    notifyListeners();
  }

  Future<void> saveBestBlockTypeCounts(String levelId, Map<String, int> blockTypes, int blocks, int stars) async {
    final currentBlocks = getBestBlocks(levelId);
    final currentStars = getStars(levelId);
    final shouldUpdate = stars > currentStars || (stars == currentStars && (currentBlocks == 0 || blocks < currentBlocks));
    if (!shouldUpdate) return;
    await _prefs?.setString('$_blockTypesPrefix$levelId', json.encode(blockTypes));
    notifyListeners();
  }

  int getBestTime(String levelId) {
    return _prefs?.getInt('$_bestTimePrefix$levelId') ?? 0;
  }

  Future<void> saveBestTime(String levelId, int milliseconds) async {
    final current = getBestTime(levelId);
    if (current != 0 && milliseconds >= current) return;
    await _prefs?.setInt('$_bestTimePrefix$levelId', milliseconds);
    notifyListeners();
  }

  int getLevelScore(String levelId) {
    return _prefs?.getInt('$_scorePrefix$levelId') ?? 0;
  }

  int get totalScore {
    return levelOrder.fold(0, (sum, id) => sum + getLevelScore(id));
  }

  Future<void> saveBestScore(String levelId, int score, int oldStars, int newStars) async {
    final currentScore = getLevelScore(levelId);
    if (oldStars == 3) return;
    if (score <= currentScore && newStars <= oldStars) return;
    final updatedScore = score > currentScore ? score : currentScore;
    await _prefs?.setInt('$_scorePrefix$levelId', updatedScore);
    notifyListeners();
  }

  int get totalStars {
    return levelOrder.fold(0, (sum, id) => sum + getStars(id));
  }

  int get levelsCompleted {
    return levelOrder.where((id) => getStars(id) > 0).length;
  }

  double get averageStars {
    final completed = levelsCompleted;
    if (completed == 0) return 0;
    return totalStars / completed;
  }

  String getOverallPerformance() {
    if (levelsCompleted == 0) return 'Aún no hay datos';
    if (averageStars >= 2.7) return 'Excelente rendimiento';
    if (averageStars >= 2.0) return 'Buen rendimiento';
    return 'Necesitas practicar más';
  }

  String getLevelPerformanceText(String levelId) {
    final stars = getStars(levelId);
    if (stars == 0) return 'Pendiente';
    if (stars == 3) return 'Excelente';
    if (stars == 2) return 'Bien';
    return 'Puede mejorar';
  }

  // ── Candado ────────────────────────────────────────────────
  bool isUnlocked(String levelId) {
    if (levelId == 'tutorial') return true;
    return _prefs?.getBool('$_unlockedPrefix$levelId') ?? false;
  }

  Future<void> _unlock(String levelId) async {
    await _prefs?.setBool('$_unlockedPrefix$levelId', true);
  }

  /// Llama esto al completar un nivel. Desbloquea el siguiente.
  Future<int> completeLevel(String levelId, int stars, int blocks, Map<String, int> blockTypes, int completionMilliseconds, int levelScore) async {
    final oldStars = getStars(levelId);
    await saveStars(levelId, stars);
    await saveBestBlocks(levelId, blocks);
    await saveBestBlockTypeCounts(levelId, blockTypes, blocks, stars);
    await saveBestTime(levelId, completionMilliseconds);
    await saveBestScore(levelId, levelScore, oldStars, stars);
    final idx = levelOrder.indexOf(levelId);
    if (idx >= 0 && idx + 1 < levelOrder.length) {
      await _unlock(levelOrder[idx + 1]);
    }
    notifyListeners();
    return getLevelScore(levelId);
  }

  Future<void> resetAll() async {
    await _prefs?.clear();
    await _unlock('tutorial');
    notifyListeners();
  }
}
