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

class BlockWidget extends StatelessWidget {
  final String name;
  final Color color;
  final IconData? icon;
  final bool isDragging;
  final VoidCallback? onTap;
  final bool compact;

  const BlockWidget({
    super.key,
    required this.name,
    required this.color,
    this.icon,
    this.isDragging = false,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isDragging ? Color.lerp(color, Colors.black, 0.25)! : color;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin:
            EdgeInsets.symmetric(vertical: compact ? 2 : 3, horizontal: 2),
        padding: EdgeInsets.symmetric(
            vertical: compact ? 8 : 10, horizontal: compact ? 8 : 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isDragging
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2)
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
                  BoxShadow(
                      color: color.withOpacity(0.15), blurRadius: 8),
                ],
          border: Border(
            top: BorderSide(color: color.withOpacity(0.6), width: 1),
            left: BorderSide(color: color.withOpacity(0.6), width: 1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: compact ? 14 : 16,
                  color: Colors.white.withOpacity(0.95)),
              SizedBox(width: compact ? 4 : 6),
            ],
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 11 : 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockCounterBadge extends StatelessWidget {
  final int count;
  const BlockCounterBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final Color color =
        count >= 9 ? AppColors.warning : AppColors.accent;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_view_rounded, size: 13, color: color),
          const SizedBox(width: 5),
          Text('$count bloques',
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4)),
        ],
      ),
    );
  }
}

class LevelScreen extends StatefulWidget {
  final LevelData level;
  const LevelScreen({super.key, required this.level});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen>
    with TickerProviderStateMixin {
  late AnimationController _executeController;
  late Animation<double> _executeScale;
  bool _isExecuting = false;
  Color? _feedbackColor;
  late List<Map<String, dynamic>> toolbox;

  List<Map<String, dynamic>> get _defaultToolbox => [
        {'name': 'Avanzar', 'code': 'A'},
        {'name': 'Giro Izq.', 'code': 'I'},
        {'name': 'Sensor', 'code': 'S'},
        {'name': 'Repetir', 'isLoop': true},
        {
          'name': 'Función',
          'isFunction': true,
          'configured': false,
          'children': <Map<String, dynamic>>[]
        },
      ];

  @override
  void initState() {
    super.initState();
    _executeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _executeScale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(
          parent: _executeController, curve: Curves.easeInOut),
    );
    if (widget.level.availableBlocks != null) {
      toolbox = widget.level.availableBlocks!.map((b) {
        return <String, dynamic>{
          'name': b.name,
          'code': b.code,
          'isLoop': b.isLoop,
          'isFunction': b.isFunction,
          if (b.isFunction) 'configured': false,
          if (b.isFunction || b.isLoop)
            'children': <Map<String, dynamic>>[],
        };
      }).toList();
    } else {
      toolbox = _defaultToolbox;
    }
  }

  @override
  void dispose() {
    _executeController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> workspaceBlocks = [];

  IconData blockIcon(Map<String, dynamic> block) {
    if (block['isLoop'] == true) return Icons.repeat_rounded;
    if (block['isFunction'] == true) return Icons.code_rounded;
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
    if (block['isLoop'] == true) return AppColors.blockLoop;
    if (block['isFunction'] == true) return AppColors.blockFunction;
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

  int countBlocks(List<Map<String, dynamic>> blocks,
      {bool isWorkspace = false}) {
    int count = 0;
    for (final block in blocks) {
      final bool isFunction = block['isFunction'] == true;
      final bool isLoop = block['isLoop'] == true;
      final List<Map<String, dynamic>>? children =
          block['children'] as List<Map<String, dynamic>>?;
      if (isFunction) {
        count += 1;
        continue;
      }
      if (isLoop) {
        count += 1;
        if (children != null) count += countBlocks(children);
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
        if (block['isFunction'] == true)
          usedFunctions.add(block['name']);
        if (block['children'] != null)
          findFunctions(block['children'] as List<Map<String, dynamic>>);
      }
    }

    findFunctions(workspaceBlocks);
    int count = 0;
    for (final block in toolbox) {
      if (block['isFunction'] == true &&
          block['configured'] == true &&
          usedFunctions.contains(block['name'])) {
        final children =
            block['children'] as List<Map<String, dynamic>>?;
        if (children != null) count += countBlocks(children);
      }
    }
    return count;
  }

  int get totalBlockCount =>
      countBlocks(workspaceBlocks, isWorkspace: true) +
      countConfiguredFunctions();

  String generateCode(List<Map<String, dynamic>> blocks) {
    String code = '';
    for (var block in blocks) {
      if (block['isLoop'] == true && block['children'] != null) {
        int times = block['times'] ?? 1;
        String childCode =
            generateCode(block['children'] as List<Map<String, dynamic>>);
        for (int i = 0; i < times; i++) code += childCode;
      } else if (block['isFunction'] == true &&
          block['children'] != null) {
        code +=
            generateCode(block['children'] as List<Map<String, dynamic>>);
      } else {
        code += block['code'] ?? '';
      }
    }
    return code;
  }

  Future<void> ejecutar() async {
    if (_isExecuting) return;
    setState(() => _isExecuting = true);
    _executeController
        .forward()
        .then((_) => _executeController.reverse());
    await Future.delayed(const Duration(milliseconds: 180));

    final code = generateCode(workspaceBlocks);
    final totalBlocks = totalBlockCount;
    initMapa();

    final bt = context.read<BluetoothManager>();
    bool colision = false;

    for (int paso = 0; paso < code.length; paso++) {
      if (!mounted) return;
      final inst = code[paso];
      if (inst == ' ') continue;

      if (inst == 'A') {
        final int nx1 = kx + dx[direccion];
        final int ny1 = ky + dy[direccion];
        final int celda1 = mapa[nx1][ny1];

        int nx, ny;

        if (celda1 == 0) {
          final int nx2 = kx + dx[direccion] * 2;
          final int ny2 = ky + dy[direccion] * 2;
          final int celda2 = mapa[nx2][ny2];

          if (celda2 == 1 || celda2 == 2) {
            nx = nx2;
            ny = ny2;
          } else {
            colision = true;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('💥 Karel chocó en paso ${paso + 1}'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ));
            }
            break;
          }
        } else {
          colision = true;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('💥 Karel chocó en paso ${paso + 1}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
          break;
        }
        kx = nx;
        ky = ny;

        if (bt.isConnected) {
          await bt.send('A');
          await Future.delayed(const Duration(milliseconds: 700));
        }
      } else if (inst == 'I') {
        direccion = (direccion + 3) % 4;
        if (bt.isConnected) {
          await bt.send('I');
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } else if (inst == 'D') {
        direccion = (direccion + 1) % 4;
        if (bt.isConnected) {
          await bt.send('D');
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } else if (inst == 'S') {
        if (mapa[kx][ky] == 2) {
          mapa[kx][ky] = 1;
          zRecogidos++;
          direccionAlRecoger = direccion;
          if (bt.isConnected) {
            await bt.send('S');
            await Future.delayed(const Duration(milliseconds: 150));
          }
        }
      }
    }

    if (!mounted) return;

    if (!bt.isConnected && !colision) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('¡Conecta el Bluetooth para ejecutar en físico!'),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    final bool ok = !colision &&
        zRecogidos == zTotales &&
        direccionAlRecoger == widget.level.winDirection;

    setState(() {
      _feedbackColor = ok ? AppColors.success : AppColors.error;
      _isExecuting = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _feedbackColor = null);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: ok
            ? AppColors.success.withOpacity(0.95)
            : AppColors.surface,
        content: Row(
          children: [
            Icon(
                ok
                    ? Icons.check_circle_rounded
                    : Icons.info_rounded,
                color: ok ? Colors.white : AppColors.accent,
                size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ok
                    ? '¡Completado! Bloques: $totalBlocks'
                    : colision
                        ? 'Karel chocó · Bloques: $totalBlocks'
                        : 'Código: $code  ·  Bloques: $totalBlocks',
                style:
                    const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    if (ok) {
      final int stars = widget.level.calculateStars(totalBlocks);
      await context
          .read<ProgressManager>()
          .completeLevel(widget.level.id, stars);

      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) showLevelCompletedDialog(totalBlocks);
    }
  }

  void showLevelCompletedDialog(int totalBlocks) {
    final int stars = widget.level.calculateStars(totalBlocks);
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppColors.accent.withOpacity(0.25), width: 1.5),
            boxShadow: [
              BoxShadow(
                  color: AppColors.accent.withOpacity(0.08),
                  blurRadius: 40,
                  spreadRadius: 5)
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
                      width: 2),
                ),
                child: const Icon(Icons.emoji_events_rounded,
                    size: 34, color: AppColors.warning),
              ),
              const SizedBox(height: 14),
              const Text('¡Nivel Completado!',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Excelente trabajo 👏',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 18),
              // ── Estrellas animadas ──────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration:
                        Duration(milliseconds: 400 + i * 150),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) => Transform.scale(
                      scale: value,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 4),
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
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.grid_view_rounded,
                        size: 14, color: AppColors.accent),
                    const SizedBox(width: 6),
                    Text('$totalBlocks bloques usados',
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/levelView');
                      },
                      style: TextButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: AppColors.textSecondary
                                  .withOpacity(0.25)),
                        ),
                      ),
                      child: const Text('Ver niveles',
                          style: TextStyle(
                              color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.bg,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Continuar',
                          style:
                              TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addBlock(Map<String, dynamic> block,
      List<Map<String, dynamic>> targetList) {
    setState(() {
      targetList.add({
        'name': block['name'],
        'code': block['code'],
        'times': block['isLoop'] == true ? 3 : null,
        'children':
            (block['isLoop'] == true || block['isFunction'] == true)
                ? List<Map<String, dynamic>>.from(
                    block['children'] ?? [])
                : null,
        'isLoop': block['isLoop'] ?? false,
        'isFunction': block['isFunction'] ?? false,
        'configured': block['configured'] ?? false,
      });
    });
  }

  void removeBlock(Map<String, dynamic> block,
      List<Map<String, dynamic>> targetList) {
    setState(() => targetList.remove(block));
  }

  void clearWorkspace() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Limpiar workspace',
            style: TextStyle(
                color: AppColors.textPrimary, fontSize: 16)),
        content: const Text('¿Eliminar todos los bloques?',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar',
                  style:
                      TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              setState(() => workspaceBlocks.clear());
              Navigator.pop(ctx);
            },
            child: const Text('Limpiar',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget buildBlock(
      Map<String, dynamic> block,
      List<Map<String, dynamic>> parentList,
      {bool isInFunctionConfig = false,
      VoidCallback? onUpdate}) {
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
      final Color cc =
          isFunction ? AppColors.blockFunction : AppColors.blockLoop;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        decoration: BoxDecoration(
          color: cc.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: cc.withOpacity(0.45), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: cc.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10)),
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
                          if (block['times'] > 1) block['times']--;
                        });
                        onUpdate?.call();
                      },
                      onIncrement: () {
                        setState(() {
                          block['times']++;
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
                      children: (block['children']
                              as List<Map<String, dynamic>>)
                          .map<Widget>((b) => buildBlock(b,
                              b['children'] ?? [],
                              onUpdate: onUpdate))
                          .toList(),
                    )
                  : DragTarget<Map<String, dynamic>>(
                      onAccept: (subBlock) {
                        addBlock(subBlock, block['children']
                            as List<Map<String, dynamic>>);
                        onUpdate?.call();
                      },
                      builder: (context, candidateData, _) {
                        final bool hovering =
                            candidateData.isNotEmpty;
                        final children = block['children']
                            as List<Map<String, dynamic>>;
                        return AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 150),
                          constraints:
                              const BoxConstraints(minHeight: 44),
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
                                  child: Text('Suelta aquí',
                                      style: TextStyle(
                                          color:
                                              cc.withOpacity(0.5),
                                          fontSize: 11)))
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: children
                                      .map<Widget>((b) => buildBlock(
                                          b, children,
                                          isInFunctionConfig:
                                              isInFunctionConfig,
                                          onUpdate: onUpdate))
                                      .toList(),
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
      onTap: () {
        removeBlock(block, parentList);
        onUpdate?.call();
      },
    );
  }

  Future<void> configureFunction(
      Map<String, dynamic> funcBlock) async {
    final Map<String, dynamic> tempFunction = {
      'name': funcBlock['name'],
      'isFunction': true,
      'children':
          List<Map<String, dynamic>>.from(funcBlock['children'] ?? []),
    };
    final nameController =
        TextEditingController(text: tempFunction['name']);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.blockFunction.withOpacity(0.35),
                  width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.blockFunction.withOpacity(0.12),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(19)),
                    border: Border(
                        bottom: BorderSide(
                            color: AppColors.blockFunction
                                .withOpacity(0.18))),
                  ),
                  child: const Row(children: [
                    Icon(Icons.code_rounded,
                        color: AppColors.blockFunction, size: 18),
                    SizedBox(width: 8),
                    Text('Configurar Función',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ]),
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
                              fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'Nombre de la función',
                            labelStyle: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12),
                            filled: true,
                            fillColor: AppColors.surfaceLight,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.blockFunction,
                                  width: 1.5),
                            ),
                            prefixIcon: const Icon(
                                Icons.label_outline_rounded,
                                color: AppColors.textSecondary,
                                size: 16),
                            contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 11),
                          ),
                          onChanged: (v) => setStateDialog(
                              () => tempFunction['name'] = v),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height *
                                  0.42,
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
                                    const Text('BLOQUES',
                                        style: TextStyle(
                                            color: AppColors
                                                .textSecondary,
                                            fontSize: 10,
                                            fontWeight:
                                                FontWeight.w700,
                                            letterSpacing: 0.7)),
                                    const SizedBox(height: 6),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color:
                                                AppColors.toolboxBg,
                                            borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                        child: ListView(
                                          children: toolbox
                                              .where((b) =>
                                                  b['isFunction'] !=
                                                  true)
                                              .map((b) =>
                                                  Draggable<
                                                      Map<String,
                                                          dynamic>>(
                                                    data: b,
                                                    feedback: Material(
                                                        color: Colors
                                                            .transparent,
                                                        child: BlockWidget(
                                                            name: b[
                                                                'name'],
                                                            color: toolboxColor(
                                                                b),
                                                            isDragging:
                                                                true,
                                                            icon: blockIcon(
                                                                b),
                                                            compact:
                                                                true)),
                                                    child: BlockWidget(
                                                        name: b[
                                                            'name'],
                                                        color:
                                                            toolboxColor(
                                                                b),
                                                        icon:
                                                            blockIcon(
                                                                b),
                                                        compact:
                                                            true),
                                                  ))
                                              .toList(),
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
                                    const Text('SECUENCIA',
                                        style: TextStyle(
                                            color: AppColors
                                                .textSecondary,
                                            fontSize: 10,
                                            fontWeight:
                                                FontWeight.w700,
                                            letterSpacing: 0.7)),
                                    const SizedBox(height: 6),
                                    Expanded(
                                      child: DragTarget<
                                          Map<String, dynamic>>(
                                        onAccept: (b) {
                                          addBlock(
                                              b,
                                              tempFunction['children']
                                                  as List<Map<String,
                                                      dynamic>>);
                                          setStateDialog(() {});
                                        },
                                        builder: (context,
                                            candidateData, _) {
                                          final children =
                                              tempFunction['children']
                                                  as List<Map<String,
                                                      dynamic>>;
                                          final bool hovering =
                                              candidateData.isNotEmpty;
                                          return AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 150),
                                            padding:
                                                const EdgeInsets.all(
                                                    7),
                                            decoration: BoxDecoration(
                                              color: hovering
                                                  ? AppColors
                                                      .blockFunction
                                                      .withOpacity(
                                                          0.08)
                                                  : AppColors
                                                      .toolboxBg,
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(10),
                                              border: Border.all(
                                                color: hovering
                                                    ? AppColors
                                                        .blockFunction
                                                        .withOpacity(
                                                            0.6)
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
                                                                    0.35),
                                                            size: 26),
                                                        const SizedBox(
                                                            height: 6),
                                                        Text(
                                                            'Arrastra bloques aquí',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .textSecondary
                                                                    .withOpacity(
                                                                        0.45),
                                                                fontSize:
                                                                    11)),
                                                      ],
                                                    ))
                                                : SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: children
                                                          .map<Widget>((b) =>
                                                              buildBlock(
                                                                  b,
                                                                  children,
                                                                  isInFunctionConfig:
                                                                      true,
                                                                  onUpdate: () =>
                                                                      setStateDialog(
                                                                          () {})))
                                                          .toList(),
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
                  padding:
                      const EdgeInsets.fromLTRB(14, 10, 14, 14),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: AppColors.surfaceLight))),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 11),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                                side: BorderSide(
                                    color: AppColors.textSecondary
                                        .withOpacity(0.2))),
                          ),
                          child: const Text('Cancelar',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              funcBlock['name'] =
                                  tempFunction['name'];
                              funcBlock['children'] =
                                  List<Map<String, dynamic>>.from(
                                      tempFunction['children']);
                              funcBlock['configured'] = true;
                            });
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check_rounded,
                              size: 15),
                          label: const Text('Guardar',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.blockFunction,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 11),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10)),
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
        ),
      ),
    );
  }

  final List<int> dx = [-1, 0, 1, 0];
  final List<int> dy = [0, 1, 0, -1];
  final List<String> dirNombre = ['Norte', 'Este', 'Sur', 'Oeste'];

  int? direccionAlRecoger;
  late List<List<int>> mapa;
  late int kx, ky;
  int direccion = 0;
  int zTotales = 0;
  int zRecogidos = 0;

  void initMapa() {
    direccion = widget.level.startDirection;
    zTotales = 0;
    zRecogidos = 0;
    direccionAlRecoger = null;

    final rawMap = widget.level.rawMap;
    final rows = rawMap.length;
    final cols = rawMap[0].length;
    mapa = List.generate(rows, (_) => List.filled(cols, 0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final v = rawMap[i][j];
        if (v == 'i') {
          mapa[i][j] = -1;
        } else {
          mapa[i][j] = int.parse(v);
          if (mapa[i][j] == 2) zTotales++;
        }
      }
    }

    kx = widget.level.startRow;
    ky = widget.level.startCol;
  }

  Future<void> showLevelImage() async {
    await showDialog(
      context: context,
      builder: (context) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: isPortrait
              ? Column(mainAxisSize: MainAxisSize.min, children: [
                  _levelImageBox(context, widget.level.imagePath1),
                  const SizedBox(height: 10),
                  const Icon(Icons.arrow_downward_rounded,
                      size: 34, color: AppColors.accent),
                  const SizedBox(height: 10),
                  _levelImageBox(context, widget.level.imagePath2),
                ])
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  _levelImageBox(context, widget.level.imagePath1),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded,
                      size: 34, color: AppColors.accent),
                  const SizedBox(width: 10),
                  _levelImageBox(context, widget.level.imagePath2),
                ]),
        );
      },
    );
  }

  Widget _levelImageBox(BuildContext context, String assetPath) {
    final size = MediaQuery.of(context).size;
    final imageSize = (size.shortestSide).clamp(170.0, 260.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
          width: imageSize,
          height: imageSize,
          child: Image.asset(assetPath, fit: BoxFit.cover)),
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
                    _buildWorkspace()
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
            color: AppColors.accent.withOpacity(0.18)),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            color: AppColors.textSecondary),
        onPressed: () => context.go('/levelView'),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.13),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.smart_toy_rounded,
                size: 17, color: AppColors.accent),
          ),
          const SizedBox(width: 10),
          Text(widget.level.title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.4)),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Center(
            child: Consumer<BluetoothManager>(
              builder: (context, bt, _) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16)),
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
                        size: 14),
                    const SizedBox(width: 4),
                    Text(
                        bt.isConnected ? 'BT' : 'Sin BT',
                        style: TextStyle(
                            color: bt.isConnected
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: BlockCounterBadge(count: totalBlockCount),
        ),
      ],
    );
  }

  Widget _buildObjectiveBanner() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
            color: AppColors.accent.withOpacity(0.13), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(7)),
            child: const Icon(Icons.flag_rounded,
                color: AppColors.accent, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(widget.level.objectiveDescription,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5))),
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
                        width: 1.5),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.accent.withOpacity(0.07),
                          blurRadius: 10)
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(widget.level.imagePath1,
                        fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.bg.withOpacity(0.82),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_out_map_rounded,
                              color: AppColors.accent, size: 10),
                          SizedBox(width: 3),
                          Text('Ver',
                              style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700)),
                        ]),
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
                    color: AppColors.surfaceLight, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(10, 9, 10, 5),
                    child: Row(children: [
                      Container(
                          width: 3,
                          height: 11,
                          decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius:
                                  BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      const Text('TOOLBOX',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7)),
                    ]),
                  ),
                  Expanded(
                    child: ListView(
                      padding:
                          const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      children: toolbox.map((b) {
                        if (b['isFunction'] == true) {
                          return Row(children: [
                            Expanded(
                              child: Draggable<
                                  Map<String, dynamic>>(
                                data: b['configured'] == true
                                    ? b
                                    : null,
                                feedback: Material(
                                    color: Colors.transparent,
                                    child: BlockWidget(
                                        name: b['name'],
                                        color: toolboxColor(b),
                                        isDragging: true,
                                        icon: blockIcon(b),
                                        compact: true)),
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
                                  if (b['configured'] != true)
                                    configureFunction(b);
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
                                          : AppColors
                                              .textSecondary)),
                            ),
                          ]);
                        }
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 3),
                          child: Draggable<Map<String, dynamic>>(
                            data: b,
                            feedback: Material(
                                color: Colors.transparent,
                                child: BlockWidget(
                                    name: b['name'],
                                    color: toolboxColor(b),
                                    isDragging: true,
                                    icon: blockIcon(b),
                                    compact: true)),
                            child: BlockWidget(
                                name: b['name'],
                                color: toolboxColor(b),
                                icon: blockIcon(b),
                                compact: true),
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
        onAccept: (block) => addBlock(block, workspaceBlocks),
        builder: (context, candidateData, _) {
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
                width:
                    hovering || _feedbackColor != null ? 1.5 : 1,
              ),
              boxShadow: hovering
                  ? [
                      BoxShadow(
                          color: AppColors.accent.withOpacity(0.1),
                          blurRadius: 16)
                    ]
                  : _feedbackColor != null
                      ? [
                          BoxShadow(
                              color: _feedbackColor!.withOpacity(0.1),
                              blurRadius: 16)
                        ]
                      : [],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(13)),
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 3,
                        height: 11,
                        decoration: BoxDecoration(
                          color:
                              _feedbackColor ?? AppColors.accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Text('WORKSPACE',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7)),
                      const Spacer(),
                      if (!empty)
                        GestureDetector(
                          onTap: clearWorkspace,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.error.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(6),
                            ),
                            child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                      Icons
                                          .delete_outline_rounded,
                                      size: 12,
                                      color: AppColors.error),
                                  SizedBox(width: 3),
                                  Text('Limpiar',
                                      style: TextStyle(
                                          color: AppColors.error,
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight.w600)),
                                ]),
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
                              Icon(Icons.drag_indicator_rounded,
                                  size: 30,
                                  color: hovering
                                      ? AppColors.accent
                                      : AppColors.textSecondary
                                          .withOpacity(0.25)),
                              const SizedBox(height: 7),
                              Text(
                                hovering
                                    ? 'Suelta el bloque'
                                    : 'Arrastra bloques aquí',
                                style: TextStyle(
                                  color: hovering
                                      ? AppColors.accent
                                      : AppColors.textSecondary
                                          .withOpacity(0.35),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(7),
                          children: workspaceBlocks
                              .map((b) =>
                                  buildBlock(b, workspaceBlocks))
                              .toList(),
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
                  ? [AppColors.accentDim, AppColors.accentDim]
                  : [
                      AppColors.accent,
                      const Color(0xFF00B4D8)
                    ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent
                    .withOpacity(_isExecuting ? 0.08 : 0.28),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
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
                    size: 21),
              ),
              const SizedBox(width: 8),
              Text(
                  _isExecuting ? 'Enviando...' : 'Ejecutar',
                  style: const TextStyle(
                      color: AppColors.bg,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4)),
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

  const _LoopCounter(
      {required this.value,
      required this.onDecrement,
      required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _btn(Icons.remove_rounded, onDecrement),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.22),
              borderRadius: BorderRadius.circular(6)),
          child: Text('$value',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ),
        _btn(Icons.add_rounded, onIncrement),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 13, color: Colors.white),
      ),
    );
  }
}
