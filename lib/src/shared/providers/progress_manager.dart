import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager extends ChangeNotifier {
  static final ProgressManager _instance = ProgressManager._internal();
  factory ProgressManager() => _instance;
  ProgressManager._internal();

  static const String _starsPrefix = 'stars_';
  static const String _unlockedPrefix = 'unlocked_';

  // IDs de niveles en orden
  static const List<String> levelOrder = ['tutorial', 'nivel_1', 'nivel_2'];

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

  Future<void> saveStars(String levelId, int stars) async {
    final current = getStars(levelId);
    if (stars <= current) return; // solo guardamos si mejora
    await _prefs?.setInt('$_starsPrefix$levelId', stars);
    notifyListeners();
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
  Future<void> completeLevel(String levelId, int stars) async {
    await saveStars(levelId, stars);
    final idx = levelOrder.indexOf(levelId);
    if (idx >= 0 && idx + 1 < levelOrder.length) {
      await _unlock(levelOrder[idx + 1]);
    }
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _prefs?.clear();
    await _unlock('tutorial');
    notifyListeners();
  }
}
