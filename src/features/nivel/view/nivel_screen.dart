import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/controllers/controllers.dart';
import '../../../shared/providers/progress_manager.dart';

class AppColors {
  static const Color bg = Color(0xFF0F1923);
  static const Color surface = Color(0xFF1A2535);
  static const Color surfaceLight = Color(0xFF243044);
  static const Color accent = Color(0xFF00D4FF);
  static const Color accentDim = Color(0xFF0099BB);
  static const Color blockAdvance = Color(0xFF2ECC71);
  static const Color blockLeft = Color(0xFF3498DB);
  static const Color blockRight = Color(0xFFE67E22);
  static const Color blockSensor = Color(0xFF9B59B6);
  static const Color blockLoop = Color(0xFFE74C3C);
  static const Color blockFunction = Color(0xFF1ABC9C);
  static const Color toolboxBg = Color(0xFF141F2E);
  static const Color textPrimary = Color(0xFFECF0F1);
  static const Color textSecondary = Color(0xFF8899AA);
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
}

class BlockWidget extends StatefulWidget {
  final String name;
  final Color color;
  final IconData? icon;
  final bool isDragging;
  final VoidCallback? onTap;
  final bool compact;
  final bool blink;
  final Color? blinkColor;

  const BlockWidget({
    super.key,
    required this.name,
    required this.color,
    this.icon,
    this.isDragging = false,
    this.onTap,
    this.compact = false,
    this.blink = false,
    this.blinkColor,
  });

  @override
  State<BlockWidget> createState() => _BlockWidgetState();
}

class _BlockWidgetState extends State<BlockWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    if (widget.blink) {
      _blinkController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant BlockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.blink && !_blinkController.isAnimating) {
      _blinkController.repeat(reverse: true);
    } else if (!widget.blink && _blinkController.isAnimating) {
      _blinkController.stop();
      _blinkController.value = 0;
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = widget.isDragging
        ? Color.lerp(widget.color, Colors.black, 0.25)!
        : widget.color;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          final Color finalColor = widget.blink && widget.blinkColor != null
              ? Color.lerp(
                  baseColor,
                  widget.blinkColor!,
                  0.35 + (_blinkController.value * 0.45),
                )!
              : baseColor;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: EdgeInsets.symmetric(
              vertical: widget.compact ? 2 : 3,
              horizontal: 2,
            ),
            padding: EdgeInsets.symmetric(
              vertical: widget.compact ? 8 : 10,
              horizontal: widget.compact ? 8 : 10,
            ),
            decoration: BoxDecoration(
              color: finalColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: widget.blink
                  ? [
                      BoxShadow(
                        color: (widget.blinkColor ?? widget.color)
                            .withOpacity(0.65),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ]
                  : widget.isDragging
                      ? [
                          BoxShadow(
                            color: widget.color.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: widget.color.withOpacity(0.15),
                            blurRadius: 8,
                          ),
                        ],
              border: Border(
                top: BorderSide(
                  color: widget.blink
                      ? (widget.blinkColor ?? widget.color)
                      : widget.color.withOpacity(0.6),
                  width: 1,
                ),
                left: BorderSide(
                  color: widget.blink
                      ? (widget.blinkColor ?? widget.color)
                      : widget.color.withOpacity(0.6),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: widget.compact ? 14 : 16,
                    color: Colors.white.withOpacity(0.95),
                  ),
                  SizedBox(width: widget.compact ? 4 : 6),
                ],
                Flexible(
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.compact ? 11 : 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BlockCounterBadge extends StatelessWidget {
  final int count;

  const BlockCounterBadge({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = count >= 9 ? AppColors.warning : AppColors.accent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.grid_view_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            '$count bloques',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class LevelScreen extends StatefulWidget {
  final LevelData level;

  const LevelScreen({
    super.key,
    required this.level,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen>
    with TickerProviderStateMixin {
  late AnimationController _executeController;
  late Animation<double> _executeScale;

  bool _isExecuting = false;
  Color? _feedbackColor;
  Timer? _timerTicker;
  late Stopwatch _stopwatch;
  String _elapsedTimeText = '00:00';

  late List<Map<String, dynamic>> toolbox;

  final List<Map<String, dynamic>> workspaceBlocks = [];

  final Set<String> _bloquesParpadeando = {
    'Avanzar',
    'Sensor',
  };

  final List<int> dx = [-1, 0, 1, 0];
  final List<int> dy = [0, 1, 0, -1];
  final List<String> dirNombre = ['Norte', 'Este', 'Sur', 'Oeste'];

  int? direccionAlRecoger;
  late List<List<int>> mapa;
  late int kx;
  late int ky;
  int direccion = 0;
  int zTotales = 0;
  int zRecogidos = 0;

  List<Map<String, dynamic>> get _defaultToolbox => [
        {
          'name': 'Avanzar',
          'code': 'A',
        },
        {
          'name': 'Giro Izq.',
          'code': 'I',
        },
        {
          'name': 'Giro Der.',
          'code': 'D',
        },
        {
          'name': 'Sensor',
          'code': 'S',
        },
        {
          'name': 'Repetir',
          'isLoop': true,
          'children': <Map<String, dynamic>>[],
        },
        {
          'name': 'Función',
          'isFunction': true,
          'configured': false,
          'children': <Map<String, dynamic>>[],
        },
      ];

  bool _debeParpadear(Map<String, dynamic> block) {
    final String name = block['name'] ?? '';
    return _bloquesParpadeando.contains(name);
  }

  void _startTimer() {
    _stopwatch.reset();
    _stopwatch.start();
    _timerTicker?.cancel();
    _timerTicker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) {
        setState(() {
          _elapsedTimeText = _formatDuration(_stopwatch.elapsed);
        });
      }
    });
  }

  void _resetTimer() {
    _stopwatch.reset();
    _elapsedTimeText = '00:00';
    _timerTicker?.cancel();
    if (mounted) {
      setState(() {});
    }
    _startTimer();
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timerTicker?.cancel();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double _difficultyFactor() {
    switch (widget.level.id) {
      case 'tutorial':
        return 0.8;
      case 'nivel_1':
        return 0.95;
      case 'nivel_2':
        return 1.05;
      case 'nivel_3':
        return 1.15;
      case 'nivel_4':
        return 1.25;
      case 'nivel_5':
        return 1.35;
      default:
        return 1.0;
    }
  }

  int _calculateLevelScore(int stars, int totalBlocks, int completionMilliseconds) {
    final difficulty = _difficultyFactor();
    final starValue = stars * 280;
    final blockBonus = totalBlocks <= widget.level.threeStarMaxBlocks
        ? 80
        : totalBlocks <= widget.level.twoStarMaxBlocks
            ? 40
            : 12;
    final seconds = (completionMilliseconds / 1000).round();
    final timeBonus = (120 - seconds).clamp(0, 120);

    final rawScore = ((starValue + blockBonus + timeBonus) * difficulty).round();
    return rawScore;
  }

  Color? _colorParpadeo(Map<String, dynamic> block) {
    final String name = block['name'] ?? '';

    if (name == 'Avanzar') {
      return AppColors.success;
    }

    if (name == 'Sensor') {
      return AppColors.error;
    }

    return null;
  }

  bool get _isTutorial => widget.level.id == 'tutorial';

  int _countCodeInBlocks(List<Map<String, dynamic>> blocks, String code) {
    int count = 0;

    for (final block in blocks) {
      if (block['code'] == code) {
        count++;
      }

      final children = block['children'];
      if (children is List) {
        count += _countCodeInBlocks(
          children.cast<Map<String, dynamic>>(),
          code,
        );
      }
    }

    return count;
  }

  Map<String, int> _countBlockTypes(List<Map<String, dynamic>> blocks) {
    final counts = <String, int>{
      'Avanzar': 0,
      'Giro Izq.': 0,
      'Giro Der.': 0,
      'Sensor': 0,
      'Repetir': 0,
      'Función': 0,
    };

    void traverse(List<Map<String, dynamic>> items) {
      for (final block in items) {
        final String name = block['name'] ?? '';
        if (counts.containsKey(name)) {
          counts[name] = counts[name]! + 1;
        }

        final children = block['children'];
        if (children is List) {
          traverse(children.cast<Map<String, dynamic>>());
        }
      }
    }

    traverse(blocks);
    return counts;
  }

  int get _tutorialStep {
    if (!_isTutorial) return 0;

    final int avanzarCount = _countCodeInBlocks(workspaceBlocks, 'A');
    final int sensorCount = _countCodeInBlocks(workspaceBlocks, 'S');

    if (avanzarCount < 4) {
      return 1;
    }

    if (sensorCount < 1) {
      return 2;
    }

    return 3;
  }

  String get _tutorialMessage {
    if (!_isTutorial) {
      return widget.level.objectiveDescription;
    }

    final int avanzarCount = _countCodeInBlocks(workspaceBlocks, 'A');

    if (_tutorialStep == 1) {
      return 'Paso 1: arrastra cuatro bloques Avanzar. Llevas $avanzarCount/4.';
    }

    if (_tutorialStep == 4) {
      return 'Paso 2: ahora arrastra el bloque Sensor.';
    }

    return widget.level.objectiveDescription;
  }

  bool get _tutorialMessageIsGreen {
    return _isTutorial && _tutorialStep == 1;
  }

  @override
  void initState() {
    super.initState();

    _executeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _executeScale = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(
      CurvedAnimation(
        parent: _executeController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.level.availableBlocks != null) {
      toolbox = widget.level.availableBlocks!.map((b) {
        return <String, dynamic>{
          'name': b.name,
          'code': b.code,
          'isLoop': b.isLoop,
          'isFunction': b.isFunction,
          if (b.isFunction) 'configured': false,
          if (b.isFunction || b.isLoop) 'children': <Map<String, dynamic>>[],
        };
      }).toList();
    } else {
      toolbox = _defaultToolbox;
    }

    _stopwatch = Stopwatch();
    _startTimer();
  }

  @override
  void dispose() {
    _timerTicker?.cancel();
    _executeController.dispose();
    super.dispose();
  }

  IconData blockIcon(Map<String, dynamic> block) {
    if (block['isLoop'] == true) {
      return Icons.repeat_rounded;
    }

    if (block['isFunction'] == true) {
      return Icons.code_rounded;
    }

    switch (block['name']) {
      case 'Avanzar':
        return Icons.north_rounded;
      case 'Giro Izq.':
        return Icons.rotate_left_rounded;
      case 'Giro Der.':
        return Icons.rotate_right_rounded;
      case 'Sensor':
        return Icons.sensors_rounded;
      default:
        return Icons.extension_rounded;
    }
  }

  Color toolboxColor(Map<String, dynamic> block) {
    if (block['isLoop'] == true) {
      return AppColors.blockLoop;
    }

    if (block['isFunction'] == true) {
      return AppColors.blockFunction;
    }

    return AppColors.toolboxBg;
  }

  Color workspaceColor(Map<String, dynamic> block) {
    switch (block['name']) {
      case 'Avanzar':
        return AppColors.blockAdvance;
      case 'Giro Izq.':
        return AppColors.blockLeft;
      case 'Giro Der.':
        return AppColors.blockRight;
      case 'Sensor':
        return AppColors.blockSensor;
      default:
        return AppColors.surfaceLight;
    }
  }

  int countBlocks(
    List<Map<String, dynamic>> blocks, {
    bool isWorkspace = false,
  }) {
    int count = 0;

    for (final block in blocks) {
      final bool isFunction = block['isFunction'] == true;
      final bool isLoop = block['isLoop'] == true;
      final children = block['children'];

      if (isFunction) {
        count += 1;
        continue;
      }

      if (isLoop) {
        count += 1;

        if (children is List) {
          count += countBlocks(
            children.cast<Map<String, dynamic>>(),
          );
        }

        continue;
      }

      count += 1;
    }

    return count;
  }

  int countConfiguredFunctions() {
    final Set<String> usedFunctions = {};

    void findFunctions(List<Map<String, dynamic>> blocks) {
      for (final block in blocks) {
        if (block['isFunction'] == true) {
          usedFunctions.add(block['name']);
        }

        final children = block['children'];
        if (children is List) {
          findFunctions(children.cast<Map<String, dynamic>>());
        }
      }
    }

    findFunctions(workspaceBlocks);

    int count = 0;

    for (final block in toolbox) {
      if (block['isFunction'] == true &&
          block['configured'] == true &&
          usedFunctions.contains(block['name'])) {
        final children = block['children'];

        if (children is List) {
          count += countBlocks(
            children.cast<Map<String, dynamic>>(),
          );
        }
      }
    }

    return count;
  }

  int get totalBlockCount {
    return countBlocks(workspaceBlocks, isWorkspace: true) +
        countConfiguredFunctions();
  }

  String generateCode(List<Map<String, dynamic>> blocks) {
    String code = '';

    for (final block in blocks) {
      final children = block['children'];

      if (block['isLoop'] == true && children is List) {
        final int times = block['times'] ?? 1;
        final String childCode = generateCode(
          children.cast<Map<String, dynamic>>(),
        );

        for (int i = 0; i < times; i++) {
          code += childCode;
        }
      } else if (block['isFunction'] == true && children is List) {
        code += generateCode(
          children.cast<Map<String, dynamic>>(),
        );
      } else {
        code += block['code'] ?? '';
      }
    }

    return code;
  }

  void addBlock(
    Map<String, dynamic> block,
    List<Map<String, dynamic>> targetList,
  ) {
    setState(() {
      targetList.add({
        'name': block['name'],
        'code': block['code'],
        'times': block['isLoop'] == true ? 3 : null,
        'children': block['isLoop'] == true || block['isFunction'] == true
            ? List<Map<String, dynamic>>.from(block['children'] ?? [])
            : null,
        'isLoop': block['isLoop'] ?? false,
        'isFunction': block['isFunction'] ?? false,
        'configured': block['configured'] ?? false,
      });

      if (block['name'] == 'Avanzar' || block['name'] == 'Sensor') {
        _bloquesParpadeando.remove(block['name']);
      }
    });
  }

  void removeBlock(
    Map<String, dynamic> block,
    List<Map<String, dynamic>> targetList,
  ) {
    setState(() {
      targetList.remove(block);
    });
  }

  void clearWorkspace() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Limpiar workspace',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
          content: const Text(
            '¿Eliminar todos los bloques?',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  workspaceBlocks.clear();
                  _bloquesParpadeando
                    ..clear()
                    ..addAll(['Avanzar', 'Sensor']);
                });

                Navigator.pop(ctx);
              },
              child: const Text(
                'Limpiar',
                style: TextStyle(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildBlock(
    Map<String, dynamic> block,
    List<Map<String, dynamic>> parentList, {
    bool isInFunctionConfig = false,
    VoidCallback? onUpdate,
  }) {
    final bool isFunction = block['isFunction'] == true;

    if (isFunction && !isInFunctionConfig) {
      return BlockWidget(
        name: block['name'],
        color: AppColors.blockFunction,
        icon: Icons.code_rounded,
        onTap: () {
          removeBlock(block, parentList);
          onUpdate?.call();
        },
      );
    }

    if (block['children'] != null) {
      final bool isConfiguredFunction =
          isFunction && block['configured'] == true;

      final Color cc = isFunction
          ? AppColors.blockFunction
          : AppColors.blockLoop;

      final children = block['children'] as List<Map<String, dynamic>>;

      return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 3,
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          color: cc.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: cc.withOpacity(0.45),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: cc.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: BlockWidget(
                      name: block['isLoop'] == true
                          ? 'Repetir'
                          : block['name'],
                      color: cc,
                      icon: blockIcon(block),
                      compact: true,
                      onTap: () {
                        removeBlock(block, parentList);
                        onUpdate?.call();
                      },
                    ),
                  ),
                  if (block['isLoop'] == true)
                    _LoopCounter(
                      value: block['times'] ?? 1,
                      onDecrement: () {
                        setState(() {
                          if ((block['times'] ?? 1) > 1) {
                            block['times']--;
                          }
                        });

                        onUpdate?.call();
                      },
                      onIncrement: () {
                        setState(() {
                          block['times'] = (block['times'] ?? 1) + 1;
                        });

                        onUpdate?.call();
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: isConfiguredFunction
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children.map<Widget>((b) {
                        return buildBlock(
                          b,
                          children,
                          onUpdate: onUpdate,
                        );
                      }).toList(),
                    )
                  : DragTarget<Map<String, dynamic>>(
                      onAccept: (subBlock) {
                        addBlock(subBlock, children);
                        onUpdate?.call();
                      },
                      builder: (context, candidateData, rejectedData) {
                        final bool hovering = candidateData.isNotEmpty;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          constraints: const BoxConstraints(
                            minHeight: 44,
                          ),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: hovering
                                ? cc.withOpacity(0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: hovering
                                  ? cc.withOpacity(0.8)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: children.isEmpty && !hovering
                              ? Center(
                                  child: Text(
                                    'Suelta aquí',
                                    style: TextStyle(
                                      color: cc.withOpacity(0.5),
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: children.map<Widget>((b) {
                                    return buildBlock(
                                      b,
                                      children,
                                      isInFunctionConfig:
                                          isInFunctionConfig,
                                      onUpdate: onUpdate,
                                    );
                                  }).toList(),
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    }

    return BlockWidget(
      name: block['name'],
      color: workspaceColor(block),
      icon: blockIcon(block),
      blink: _debeParpadear(block),
      blinkColor: _colorParpadeo(block),
      onTap: () {
        removeBlock(block, parentList);
        onUpdate?.call();
      },
    );
  }

  Future<void> configureFunction(
    Map<String, dynamic> funcBlock,
  ) async {
    final Map<String, dynamic> tempFunction = {
      'name': funcBlock['name'],
      'isFunction': true,
      'children': List<Map<String, dynamic>>.from(
        funcBlock['children'] ?? [],
      ),
    };

    final TextEditingController nameController = TextEditingController(
      text: tempFunction['name'],
    );

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.blockFunction.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blockFunction.withOpacity(0.12),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(19),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color:
                                AppColors.blockFunction.withOpacity(0.18),
                          ),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.code_rounded,
                            color: AppColors.blockFunction,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Configurar Función',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Nombre de la función',
                                labelStyle: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                                filled: true,
                                fillColor: AppColors.surfaceLight,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.blockFunction,
                                    width: 1.5,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.label_outline_rounded,
                                  color: AppColors.textSecondary,
                                  size: 16,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 11,
                                ),
                              ),
                              onChanged: (v) {
                                setStateDialog(() {
                                  tempFunction['name'] = v;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.42,
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 108,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'BLOQUES',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.7,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Expanded(
                                          child: Container(
                                            padding:
                                                const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColors.toolboxBg,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListView(
                                              children: toolbox
                                                  .where(
                                                    (b) =>
                                                        b['isFunction'] !=
                                                        true,
                                                  )
                                                  .map((b) {
                                                return Draggable<
                                                    Map<String, dynamic>>(
                                                  data: b,
                                                  feedback: Material(
                                                    color:
                                                        Colors.transparent,
                                                    child: BlockWidget(
                                                      name: b['name'],
                                                      color:
                                                          toolboxColor(b),
                                                      isDragging: true,
                                                      icon: blockIcon(b),
                                                      compact: true,
                                                    ),
                                                  ),
                                                  child: BlockWidget(
                                                    name: b['name'],
                                                    color: toolboxColor(b),
                                                    icon: blockIcon(b),
                                                    compact: true,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'SECUENCIA',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.7,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Expanded(
                                          child:
                                              DragTarget<Map<String, dynamic>>(
                                            onAccept: (b) {
                                              addBlock(
                                                b,
                                                tempFunction['children']
                                                    as List<
                                                        Map<String,
                                                            dynamic>>,
                                              );

                                              setStateDialog(() {});
                                            },
                                            builder: (
                                              context,
                                              candidateData,
                                              rejectedData,
                                            ) {
                                              final children =
                                                  tempFunction['children']
                                                      as List<
                                                          Map<String,
                                                              dynamic>>;

                                              final bool hovering =
                                                  candidateData.isNotEmpty;

                                              return AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 150,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: hovering
                                                      ? AppColors
                                                          .blockFunction
                                                          .withOpacity(0.08)
                                                      : AppColors.toolboxBg,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  border: Border.all(
                                                    color: hovering
                                                        ? AppColors
                                                            .blockFunction
                                                            .withOpacity(0.6)
                                                        : AppColors
                                                            .surfaceLight,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: children.isEmpty
                                                    ? Center(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .drag_indicator_rounded,
                                                              color: AppColors
                                                                  .textSecondary
                                                                  .withOpacity(
                                                                0.35,
                                                              ),
                                                              size: 26,
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Text(
                                                              'Arrastra bloques aquí',
                                                              style:
                                                                  TextStyle(
                                                                color: AppColors
                                                                    .textSecondary
                                                                    .withOpacity(
                                                                  0.45,
                                                                ),
                                                                fontSize: 11,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: children
                                                              .map<Widget>(
                                                                  (b) {
                                                            return buildBlock(
                                                              b,
                                                              children,
                                                              isInFunctionConfig:
                                                                  true,
                                                              onUpdate: () {
                                                                setStateDialog(
                                                                  () {},
                                                                );
                                                              },
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColors.surfaceLight,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: AppColors.textSecondary
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  funcBlock['name'] = tempFunction['name'];
                                  funcBlock['children'] =
                                      List<Map<String, dynamic>>.from(
                                    tempFunction['children'],
                                  );
                                  funcBlock['configured'] = true;
                                });

                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.check_rounded,
                                size: 15,
                              ),
                              label: const Text(
                                'Guardar',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blockFunction,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void initMapa() {
    direccion = widget.level.startDirection;
    zTotales = 0;
    zRecogidos = 0;
    direccionAlRecoger = null;

    final rawMap = widget.level.rawMap;
    final int rows = rawMap.length;
    final int cols = rawMap[0].length;

    mapa = List.generate(
      rows,
      (_) => List.filled(cols, 0),
    );

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final v = rawMap[i][j];

        if (v == 'i') {
          mapa[i][j] = -1;
        } else {
          mapa[i][j] = int.parse(v);

          if (mapa[i][j] == 2) {
            zTotales++;
          }
        }
      }
    }

    kx = widget.level.startRow;
    ky = widget.level.startCol;
  }

  Future<void> ejecutar() async {
    if (_isExecuting) return;

    setState(() {
      _isExecuting = true;
    });

    _executeController.forward().then((_) {
      _executeController.reverse();
    });

    await Future.delayed(
      const Duration(milliseconds: 180),
    );

    final String code = generateCode(workspaceBlocks);
    final int totalBlocks = totalBlockCount;
    final blockTypeCounts = _countBlockTypes(workspaceBlocks);
    await context.read<ProgressManager>().incrementRunAttempts(widget.level.id);
    await context.read<ProgressManager>().incrementBlockTypeUsage(
          widget.level.id,
          blockTypeCounts,
        );

    initMapa();

    final BluetoothManager bt = context.read<BluetoothManager>();

    bool colision = false;

    for (int paso = 0; paso < code.length; paso++) {
      if (!mounted) return;

      final String inst = code[paso];

      if (inst == ' ') continue;

      if (inst == 'A') {
        final int nx1 = kx + dx[direccion];
        final int ny1 = ky + dy[direccion];
        final int celda1 = mapa[nx1][ny1];

        int nx;
        int ny;

        if (celda1 == 0) {
          final int nx2 = kx + dx[direccion] * 2;
          final int ny2 = ky + dy[direccion] * 2;
          final int celda2 = mapa[nx2][ny2];

          if (celda2 == 1 || celda2 == 2) {
            nx = nx2;
            ny = ny2;
          } else {
            colision = true;

            await context.read<ProgressManager>().incrementCollisionAttempts(widget.level.id);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '💥 Karel chocó en paso ${paso + 1}',
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }

            break;
          }
        } else {
          colision = true;

          await context.read<ProgressManager>().incrementCollisionAttempts(widget.level.id);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '💥 Karel chocó en paso ${paso + 1}',
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          break;
        }

        kx = nx;
        ky = ny;

        if (bt.isConnected) {
          await bt.send('A');
          await Future.delayed(
            const Duration(milliseconds: 150),
          );
        }
      } else if (inst == 'I') {
        direccion = (direccion + 3) % 4;

        if (bt.isConnected) {
          await bt.send('I');
          await Future.delayed(
            const Duration(milliseconds: 150),
          );
        }
      } else if (inst == 'D') {
        direccion = (direccion + 1) % 4;

        if (bt.isConnected) {
          await bt.send('D');
          await Future.delayed(
            const Duration(milliseconds: 150),
          );
        }
      } else if (inst == 'S') {
        if (mapa[kx][ky] == 2) {
          mapa[kx][ky] = 1;
          zRecogidos++;
          direccionAlRecoger = direccion;

          if (bt.isConnected) {
            await bt.send('S');
            await Future.delayed(
              const Duration(milliseconds: 150),
            );
          }
        }
      }
    }

    if (!mounted) return;

    if (!bt.isConnected && !colision) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '¡Conecta el Bluetooth para ejecutar en físico!',
          ),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    final bool ok = !colision &&
        zRecogidos == zTotales &&
        direccionAlRecoger == widget.level.winDirection;

    if (!ok && !colision) {
      await context.read<ProgressManager>().incrementNonCompletionAttempts(widget.level.id);
    }

    setState(() {
      _feedbackColor = ok ? AppColors.success : AppColors.error;
      _isExecuting = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _feedbackColor = null;
        });
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor:
            ok ? AppColors.success.withOpacity(0.95) : AppColors.surface,
        content: Row(
          children: [
            Icon(
              ok ? Icons.check_circle_rounded : Icons.info_rounded,
              color: ok ? Colors.white : AppColors.accent,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ok
                    ? '¡Completado! Bloques: $totalBlocks'
                    : colision
                        ? 'Karel chocó · Bloques: $totalBlocks'
                        : 'Código: $code  ·  Bloques: $totalBlocks',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    if (ok) {
      _stopTimer();
      final int completionMilliseconds = _stopwatch.elapsedMilliseconds;
      final int stars = widget.level.calculateStars(totalBlocks);
      final blockTypeCounts = _countBlockTypes(workspaceBlocks);
      final int earnedPoints = _calculateLevelScore(stars, totalBlocks, completionMilliseconds);

      final int totalScore = await context.read<ProgressManager>().completeLevel(
            widget.level.id,
            stars,
            totalBlocks,
            blockTypeCounts,
            completionMilliseconds,
            earnedPoints,
          );

      await Future.delayed(
        const Duration(milliseconds: 400),
      );

      if (mounted) {
        showLevelCompletedDialog(totalBlocks, earnedPoints, totalScore);
      }
    }
  }

  void showLevelCompletedDialog(int totalBlocks, int earnedPoints, int totalScore) {
    final int stars = widget.level.calculateStars(totalBlocks);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.08),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.35),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    size: 34,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  '¡Nivel Completado!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Excelente trabajo 👏',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0.0,
                        end: 1.0,
                      ),
                      duration: Duration(
                        milliseconds: 400 + i * 150,
                      ),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            child: Icon(
                              i < stars
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: i < stars
                                  ? AppColors.warning
                                  : AppColors.textSecondary,
                              size: 42,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.grid_view_rounded,
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$totalBlocks bloques usados',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Puntos obtenidos',
                              style: TextStyle(
                                color: AppColors.accent.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$earnedPoints',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total acumulado',
                              style: TextStyle(
                                color: AppColors.accent.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalScore',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.go('/levelView');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: AppColors.textSecondary.withOpacity(
                                0.25,
                              ),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Ver niveles',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _resetTimer();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.bg,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showLevelImage() async {
    await showDialog(
      context: context,
      builder: (context) {
        final bool isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: isPortrait
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _levelImageBox(
                      context,
                      widget.level.imagePath1,
                    ),
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      size: 34,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 10),
                    _levelImageBox(
                      context,
                      widget.level.imagePath2,
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _levelImageBox(
                      context,
                      widget.level.imagePath1,
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 34,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 10),
                    _levelImageBox(
                      context,
                      widget.level.imagePath2,
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _levelImageBox(
    BuildContext context,
    String assetPath,
  ) {
    final Size size = MediaQuery.of(context).size;
    final double imageSize = size.shortestSide.clamp(170.0, 260.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home/homeBg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Column(
            children: [
              _buildObjectiveBanner(),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildToolbox(),
                    const SizedBox(width: 8),
                    _buildWorkspace(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildExecuteButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.accent.withOpacity(0.18),
        ),
      ),
      leadingWidth: 180,
      leading: SizedBox(
        width: 180,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textSecondary,
              ),
              onPressed: () => context.go('/levelView'),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _elapsedTimeText,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.13),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              size: 17,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.level.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Center(
            child: Consumer<BluetoothManager>(
              builder: (context, bt, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        bt.isConnected
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth_disabled,
                        color: bt.isConnected
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bt.isConnected ? 'BT' : 'Sin BT',
                        style: TextStyle(
                          color: bt.isConnected
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: BlockCounterBadge(
            count: totalBlockCount,
          ),
        ),
      ],
    );
  }

  Widget _buildObjectiveBanner() {
    final Color bannerColor =
        _tutorialMessageIsGreen ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: bannerColor.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: bannerColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              Icons.flag_rounded,
              color: bannerColor,
              size: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _tutorialMessage,
              style: TextStyle(
                color: bannerColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbox() {
    return SizedBox(
      width: 128,
      child: Column(
        children: [
          GestureDetector(
            onTap: showLevelImage,
            child: Stack(
              children: [
                Container(
                  height: 105,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.28),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.07),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(
                      widget.level.imagePath1,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bg.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.zoom_out_map_rounded,
                          color: AppColors.accent,
                          size: 10,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Ver',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.surfaceLight,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 9, 10, 5),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: 11,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'TOOLBOX',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      children: toolbox.map((b) {
                        if (b['isFunction'] == true) {
                          return Row(
                            children: [
                              Expanded(
                                child: Draggable<Map<String, dynamic>>(
                                  data: b['configured'] == true ? b : null,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: BlockWidget(
                                      name: b['name'],
                                      color: toolboxColor(b),
                                      isDragging: true,
                                      icon: blockIcon(b),
                                      compact: true,
                                    ),
                                  ),
                                  child: BlockWidget(
                                    name: b['name'],
                                    color: b['configured'] == true
                                        ? AppColors.blockFunction
                                        : AppColors.blockFunction
                                            .withOpacity(0.45),
                                    icon: blockIcon(b),
                                    compact: true,
                                  ),
                                  onDragStarted: () {
                                    if (b['configured'] != true) {
                                      configureFunction(b);
                                    }
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () => configureFunction(b),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.settings_rounded,
                                    size: 14,
                                    color: b['configured'] == true
                                        ? AppColors.blockFunction
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Draggable<Map<String, dynamic>>(
                            data: b,
                            feedback: Material(
                              color: Colors.transparent,
                              child: BlockWidget(
                                name: b['name'],
                                color: toolboxColor(b),
                                isDragging: true,
                                icon: blockIcon(b),
                                compact: true,
                                blink: _debeParpadear(b),
                                blinkColor: _colorParpadeo(b),
                              ),
                            ),
                            child: BlockWidget(
                              name: b['name'],
                              color: toolboxColor(b),
                              icon: blockIcon(b),
                              compact: true,
                              blink: _debeParpadear(b),
                              blinkColor: _colorParpadeo(b),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspace() {
    final bool empty = workspaceBlocks.isEmpty;

    return Expanded(
      flex: 3,
      child: DragTarget<Map<String, dynamic>>(
        onAccept: (block) {
          addBlock(block, workspaceBlocks);
        },
        builder: (context, candidateData, rejectedData) {
          final bool hovering = candidateData.isNotEmpty;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hovering
                    ? AppColors.accent.withOpacity(0.75)
                    : _feedbackColor != null
                        ? _feedbackColor!.withOpacity(0.4)
                        : AppColors.surfaceLight,
                width: hovering || _feedbackColor != null ? 1.5 : 1,
              ),
              boxShadow: hovering
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.1),
                        blurRadius: 16,
                      ),
                    ]
                  : _feedbackColor != null
                      ? [
                          BoxShadow(
                            color: _feedbackColor!.withOpacity(0.1),
                            blurRadius: 16,
                          ),
                        ]
                      : [],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(13),
                    ),
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 3,
                        height: 11,
                        decoration: BoxDecoration(
                          color: _feedbackColor ?? AppColors.accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Text(
                        'WORKSPACE',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const Spacer(),
                      if (!empty)
                        GestureDetector(
                          onTap: clearWorkspace,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  size: 12,
                                  color: AppColors.error,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Limpiar',
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: empty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.drag_indicator_rounded,
                                size: 30,
                                color: hovering
                                    ? AppColors.accent
                                    : AppColors.textSecondary.withOpacity(
                                        0.25,
                                      ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                hovering
                                    ? 'Suelta el bloque'
                                    : 'Arrastra bloques aquí',
                                style: TextStyle(
                                  color: hovering
                                      ? AppColors.accent
                                      : AppColors.textSecondary.withOpacity(
                                          0.35,
                                        ),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(7),
                          children: workspaceBlocks.map((b) {
                            return buildBlock(
                              b,
                              workspaceBlocks,
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExecuteButton() {
    return ScaleTransition(
      scale: _executeScale,
      child: GestureDetector(
        onTap: _isExecuting ? null : ejecutar,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isExecuting
                  ? [
                      AppColors.accentDim,
                      AppColors.accentDim,
                    ]
                  : [
                      AppColors.accent,
                      Color(0xFF00B4D8),
                    ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(
                  _isExecuting ? 0.08 : 0.28,
                ),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRotation(
                turns: _isExecuting ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Icon(
                  _isExecuting
                      ? Icons.sync_rounded
                      : Icons.play_arrow_rounded,
                  color: AppColors.bg,
                  size: 21,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isExecuting ? 'Enviando...' : 'Ejecutar',
                style: const TextStyle(
                  color: AppColors.bg,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoopCounter extends StatelessWidget {
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _LoopCounter({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _btn(
          Icons.remove_rounded,
          onDecrement,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.22),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _btn(
          Icons.add_rounded,
          onIncrement,
        ),
      ],
    );
  }

  Widget _btn(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}