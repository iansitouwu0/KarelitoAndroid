import 'package:flutter/material.dart';


enum CellType {
  empty,    // 0 - White/empty
  wall,     // 1 - Black/wall  
  beeper;   // 2 - Red/beeper

  String toGridValue() {
    switch (this) {
      case CellType.empty:
        return '0';
      case CellType.wall:
        return '1';
      case CellType.beeper:
        return '2';
    }
  }

  static CellType fromValue(String value) {
    switch (value) {
      case '0':
        return CellType.empty;
      case '1':
        return CellType.wall;
      case '2':
        return CellType.beeper;
      case 'i':
        return CellType.wall;
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
    }
  }
}

/// Map builder widget - Interactive grid editor WITHOUT W/S in matrix
class MapBuilder extends StatefulWidget {
  final int width;
  final int height;
  final List<List<String>> initialData;
  final Function(List<List<String>>) onMapChanged;
  final int? startRow;  // Only for display overlay
  final int? startCol;  // Only for display overlay
  final int? winRow;    // Only for display overlay
  final int? winCol;    // Only for display overlay
  final Function(int, int)? onStartChanged;
  final Function(int, int)? onWinChanged;

  const MapBuilder({
    required this.width,
    required this.height,
    required this.initialData,
    required this.onMapChanged,
    this.startRow,
    this.startCol,
    this.winRow,
    this.winCol,
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
  bool _showStartMarker = true;
  bool _showWinMarker = true;

  @override
  void initState() {
    super.initState();
    gridData = widget.initialData.map((row) => List<String>.from(row)).toList();
    startRow = widget.startRow ?? 1;
    startCol = widget.startCol ?? 1;
    winRow = widget.winRow ?? 1;
    winCol = widget.winCol ?? widget.width - 2;
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
      gridData[row][col] = selectedTool.toGridValue();
      widget.onMapChanged(gridData);
    });
  }

  void _handleStartMarker(int row, int col) {
    if (row == 0 || row == widget.height - 1 || col == 0 || col == widget.width - 1) {
      return;
    }
    setState(() {
      startRow = row;
      startCol = col;
    });
    widget.onStartChanged?.call(row, col);
  }

  void _handleWinMarker(int row, int col) {
    if (row == 0 || row == widget.height - 1 || col == 0 || col == widget.width - 1) {
      return;
    }
    setState(() {
      winRow = row;
      winCol = col;
    });
    widget.onWinChanged?.call(row, col);
  }

  void _fillBorder() {
    setState(() {
      for (int i = 0; i < widget.height; i++) {
        for (int j = 0; j < widget.width; j++) {
          if (i == 0 || i == widget.height - 1 || j == 0 || j == widget.width - 1) {
            gridData[i][j] = '1';
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
            gridData[i][j] = '1';
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
    final cellSize = (MediaQuery.of(context).size.width - 32) / widget.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tool Selection
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
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Markers toggle
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text(
                    'Show Start Position',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  value: _showStartMarker,
                  onChanged: (value) {
                    setState(() => _showStartMarker = value ?? true);
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.black,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text(
                    'Show Win Position',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  value: _showWinMarker,
                  onChanged: (value) {
                    setState(() => _showWinMarker = value ?? true);
                  },
                  activeColor: Colors.blue,
                  checkColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _fillBorder,
                  icon: const Icon(Icons.border_all, size: 18),
                  label: const Text('Border', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _fillRandom,
                  icon: const Icon(Icons.shuffle, size: 18),
                  label: const Text('Random', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Clear', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

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
                  final isStart = _showStartMarker && row == startRow && col == startCol;
                  final isWin = _showWinMarker && row == winRow && col == winCol;

                  return GestureDetector(
                    onTap: () => _handleCellTap(row, col),
                    onLongPress: () => _handleStartMarker(row, col),
                    child: Stack(
                      children: [
                        // Cell background
                        Container(
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
                        // Start position marker (green arrow)
                        if (isStart)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.3),
                              border: Border.all(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'S',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: cellSize * 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        // Win position marker (blue flag)
                        if (isWin)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: cellSize * 0.6,
                              height: cellSize * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  'W',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: cellSize * 0.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2535),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grid: ${widget.width}×${widget.height}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => _handleWinMarker(winRow, winCol),
                      child: Text(
                        'Tap win marker to change',
                        style: TextStyle(color: Colors.blue, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Start: ($startCol, $startRow) | Win: ($winCol, $winRow)',
                  style: const TextStyle(color: Colors.cyan, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  '(Long-press cells to set start, tap info to set win)',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
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
