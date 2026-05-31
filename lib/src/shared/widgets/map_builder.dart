import 'package:flutter/material.dart';

/// Map cell types
enum CellType {
  empty,    // 0 - White/empty
  wall,     // i - Black/wall
  beeper,   // 2 - Red/beeper
  start,    // S - Green/start position
  win;      // W - Blue/win position

  String toGridValue() {
    switch (this) {
      case CellType.empty:
        return '0';
      case CellType.wall:
        return 'i';
      case CellType.beeper:
        return '2';
      case CellType.start:
        return 'S';
      case CellType.win:
        return 'W';
    }
  }

  static CellType fromValue(String value) {
    switch (value) {
      case '0':
        return CellType.empty;
      case 'i':
        return CellType.wall;
      case '2':
        return CellType.beeper;
      case 'S':
        return CellType.start;
      case 'W':
        return CellType.win;
      default:
        return CellType.empty;
    }
  }

  Color getColor() {
    switch (this) {
      case CellType.empty:
        return Colors.white;
      case CellType.wall:
        return Colors.black;
      case CellType.beeper:
        return Colors.red;
      case CellType.start:
        return Colors.green;
      case CellType.win:
        return Colors.blue;
    }
  }

  Color getTextColor() {
    switch (this) {
      case CellType.wall:
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  String getLabel() {
    switch (this) {
      case CellType.empty:
        return '';
      case CellType.wall:
        return '🧱';
      case CellType.beeper:
        return '🔔';
      case CellType.start:
        return 'S';
      case CellType.win:
        return 'W';
    }
  }
}

/// Map builder widget - Interactive grid editor
class MapBuilder extends StatefulWidget {
  final int width;
  final int height;
  final List<List<String>> initialData;
  final Function(List<List<String>>) onMapChanged;
  final int startRow;
  final int startCol;
  final int winRow;
  final int winCol;
  final Function(int, int)? onStartChanged;
  final Function(int, int)? onWinChanged;

  const MapBuilder({
    required this.width,
    required this.height,
    required this.initialData,
    required this.onMapChanged,
    this.startRow = 1,
    this.startCol = 1,
    this.winRow = 1,
    this.winCol = 5,
    this.onStartChanged,
    this.onWinChanged,
    super.key,
  });

  @override
  State<MapBuilder> createState() => _MapBuilderState();
}

class _MapBuilderState extends State<MapBuilder> {
  late List<List<String>> gridData;
  CellType selectedTool = CellType.wall;
  late int startRow;
  late int startCol;
  late int winRow;
  late int winCol;

  @override
  void initState() {
    super.initState();
    gridData = widget.initialData.map((row) => List<String>.from(row)).toList();
    startRow = widget.startRow;
    startCol = widget.startCol;
    winRow = widget.winRow;
    winCol = widget.winCol;
  }

  void _handleCellTap(int row, int col) {
    // Don't allow editing border cells
    if (row == 0 || row == widget.height - 1 || col == 0 || col == widget.width - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot edit border cells')),
      );
      return;
    }

    setState(() {
      if (selectedTool == CellType.start) {
        // Remove old start
        gridData[startRow][startCol] = '0';
        startRow = row;
        startCol = col;
        gridData[row][col] = 'S';
        widget.onStartChanged?.call(row, col);
      } else if (selectedTool == CellType.win) {
        // Remove old win
        gridData[winRow][winCol] = '0';
        winRow = row;
        winCol = col;
        gridData[row][col] = 'W';
        widget.onWinChanged?.call(row, col);
      } else {
        gridData[row][col] = selectedTool.toGridValue();
      }
      widget.onMapChanged(gridData);
    });
  }

  void _fillBorder() {
    setState(() {
      for (int i = 0; i < widget.height; i++) {
        for (int j = 0; j < widget.width; j++) {
          if (i == 0 || i == widget.height - 1 || j == 0 || j == widget.width - 1) {
            gridData[i][j] = 'i';
          }
        }
      }
      widget.onMapChanged(gridData);
    });
  }

  void _clearAll() {
    setState(() {
      for (int i = 0; i < widget.height; i++) {
        for (int j = 0; j < widget.width; j++) {
          gridData[i][j] = '0';
        }
      }
      // Restore border
      _fillBorder();
      widget.onMapChanged(gridData);
    });
  }

  void _fillRandom() {
    setState(() {
      _fillBorder();
      for (int i = 1; i < widget.height - 1; i++) {
        for (int j = 1; j < widget.width - 1; j++) {
          final random = (i + j) % 3;
          if (random == 0) {
            gridData[i][j] = 'i';
          } else {
            gridData[i][j] = '0';
          }
        }
      }
      widget.onMapChanged(gridData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cellSize = MediaQuery.of(context).size.width / (widget.width + 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tool Selection
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Map Editor Tools',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              // Tool buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildToolButton(
                      CellType.empty,
                      'Empty',
                      Icons.square_outlined,
                    ),
                    _buildToolButton(
                      CellType.wall,
                      'Wall',
                      Icons.square,
                    ),
                    _buildToolButton(
                      CellType.beeper,
                      'Beeper',
                      Icons.circle,
                    ),
                    _buildToolButton(
                      CellType.start,
                      'Start',
                      Icons.play_arrow,
                    ),
                    _buildToolButton(
                      CellType.win,
                      'Win',
                      Icons.flag,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Action buttons
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _fillBorder,
                    icon: const Icon(Icons.border_all),
                    label: const Text('Border'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _fillRandom,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Random'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.delete),
                    label: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Grid
        Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.width,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: widget.width * widget.height,
              itemBuilder: (context, index) {
                final row = index ~/ widget.width;
                final col = index % widget.width;
                final cellValue = gridData[row][col];
                final cellType = CellType.fromValue(cellValue);

                return GestureDetector(
                  onTap: () => _handleCellTap(row, col),
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: cellType.getColor(),
                      border: Border.all(
                        color: Colors.grey[600]!,
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cellType.getLabel(),
                        style: TextStyle(
                          color: cellType.getTextColor(),
                          fontSize: cellSize * 0.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Info
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2535),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grid: ${widget.width}×${widget.height}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  'Start: ($startCol, $startRow)',
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
                Text(
                  'Win: ($winCol, $winRow)',
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolButton(CellType type, String label, IconData icon) {
    final isSelected = selectedTool == type;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          setState(() => selectedTool = type);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.cyan : Colors.grey[700],
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}