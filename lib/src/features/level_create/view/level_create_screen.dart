import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/level_model.dart';
import '../../../shared/providers/providers.dart';
import 'package:karelito/src/shared/widgets/widgets.dart';

class LevelCreateScreen extends StatefulWidget {
  const LevelCreateScreen({super.key});

  @override
  State<LevelCreateScreen> createState() => _LevelCreateScreenState();
}

class _LevelCreateScreenState extends State<LevelCreateScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  late List<List<String>> mapData;
  int mapStartRow = 1;
  int mapStartCol = 1;
  int mapWinRow = 1;
  int mapWinCol = 5;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    mapData = _createDefaultMap();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<List<String>> _createDefaultMap() {
    return List.generate(
      7,
      (i) => List.generate(7, (j) {
        if (i == 0 || i == 6 || j == 0 || j == 6) return 'i';
        return '0';
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Level',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<LevelCreateProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildProgressSteps(),
              ),
              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    _buildBasicInfoPage(provider),
                    _buildMapDesignerPage(provider),
                    _buildDifficultyPage(provider),
                    _buildPreviewPage(provider),
                    MapBuilder(
                      width: 7, // Your grid width
                      height: 7, // Your grid height
                      initialData: mapData, // The matrix (0, 1, 2, i only)
                      onMapChanged: (newMap) {
                        setState(() => mapData = newMap);
                      },
                      startRow: mapStartRow, // Separate variable
                      startCol: mapStartCol, // Separate variable
                      winRow: mapWinRow, // Separate variable
                      winCol: mapWinCol, // Separate variable
                      onStartChanged: (row, col) {
                        setState(() {
                          mapStartRow = row;
                          mapStartCol = col;
                        });
                      },
                      onWinChanged: (row, col) {
                        setState(() {
                          mapWinRow = row;
                          mapWinCol = col;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _currentPage > 0
                          ? () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _currentPage < 3
                          ? () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                          : () => _submitLevel(context, provider),
                      icon: Icon(
                        _currentPage < 3 ? Icons.arrow_forward : Icons.check,
                      ),
                      label: Text(_currentPage < 3 ? 'Next' : 'Create Level'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressSteps() {
    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage >= index ? Colors.cyan : Colors.grey,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ['Basic Info', 'Map Design', 'Difficulty', 'Preview'][index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: _currentPage >= index ? Colors.white : Colors.white38,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBasicInfoPage(LevelCreateProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Level Title',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) => provider.setTitle(value),
            decoration: InputDecoration(
              hintText: 'Enter level title',
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 24),
          const Text(
            'Description',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) => provider.setDescription(value),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe what players need to do',
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 24),
          const Text(
            'Map Size',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Width',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<int>(
                      value: provider.mapWidth,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF16213E),
                      items: List.generate(
                        10,
                        (i) => DropdownMenuItem(
                          value: i + 5,
                          child: Text(
                            '${i + 5}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) provider.setMapWidth(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Height',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<int>(
                      value: provider.mapHeight,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF16213E),
                      items: List.generate(
                        10,
                        (i) => DropdownMenuItem(
                          value: i + 5,
                          child: Text(
                            '${i + 5}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) provider.setMapHeight(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Visibility',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<LevelVisibility>(
            segments: const [
              ButtonSegment(
                value: LevelVisibility.public,
                label: Text('Public'),
              ),
              ButtonSegment(
                value: LevelVisibility.private,
                label: Text('Private'),
              ),
            ],
            selected: {provider.visibility},
            onSelectionChanged: (Set<LevelVisibility> newSelection) {
              provider.setVisibility(newSelection.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapDesignerPage(LevelCreateProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Map Designer',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'i = Wall, 0 = Empty, 1 = Floor, 2 = Beeper',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 24),
          // Grid editor would go here
          // This is complex, so in practice you'd use a visual grid editor
          const Text(
            'Visual Grid Editor Coming Soon',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          const Text(
            'Karel Start Position & Direction',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Row',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        provider.setStartRow(int.tryParse(value) ?? 1);
                      },
                      decoration: InputDecoration(
                        hintText: '1',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Column',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        provider.setStartCol(int.tryParse(value) ?? 1);
                      },
                      decoration: InputDecoration(
                        hintText: '1',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Start Direction',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('North ↑')),
              ButtonSegment(value: 1, label: Text('East →')),
              ButtonSegment(value: 2, label: Text('South ↓')),
              ButtonSegment(value: 3, label: Text('West ←')),
            ],
            selected: {provider.startDirection},
            onSelectionChanged: (Set<int> newSelection) {
              provider.setStartDirection(newSelection.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyPage(LevelCreateProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Difficulty Level',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<LevelDifficulty>(
            segments: const [
              ButtonSegment(value: LevelDifficulty.easy, label: Text('Easy')),
              ButtonSegment(
                value: LevelDifficulty.medium,
                label: Text('Medium'),
              ),
              ButtonSegment(value: LevelDifficulty.hard, label: Text('Hard')),
            ],
            selected: {provider.difficulty},
            onSelectionChanged: (Set<LevelDifficulty> newSelection) {
              provider.setDifficulty(newSelection.first);
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Star Requirements',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _buildStarRequirement(
            label: '⭐⭐⭐ 3 Stars',
            description: 'Solve with this many blocks or fewer',
            initialValue: provider.threeStarMaxBlocks,
            onChanged: (value) => provider.setThreeStarMaxBlocks(value),
          ),
          const SizedBox(height: 16),
          _buildStarRequirement(
            label: '⭐⭐ 2 Stars',
            description: 'Solve with this many blocks or fewer',
            initialValue: provider.twoStarMaxBlocks,
            onChanged: (value) => provider.setTwoStarMaxBlocks(value),
          ),
          const SizedBox(height: 16),
          const Text(
            '⭐ 1 Star: Any solution that completes the level',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRequirement({
    required String label,
    required String description,
    required int initialValue,
    required Function(int) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2535),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Max blocks:',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white70),
                onPressed: initialValue > 1
                    ? () => onChanged(initialValue - 1)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$initialValue',
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white70),
                onPressed: () => onChanged(initialValue + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPage(LevelCreateProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review Your Level',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          _buildPreviewField('Title', provider.title),
          _buildPreviewField('Description', provider.description),
          _buildPreviewField('Difficulty', provider.difficulty.name),
          _buildPreviewField(
            'Map Size',
            '${provider.mapWidth}x${provider.mapHeight}',
          ),
          _buildPreviewField('Visibility', provider.visibility.name),
          _buildPreviewField(
            '3-Star Max Blocks',
            '${provider.threeStarMaxBlocks}',
          ),
          _buildPreviewField(
            '2-Star Max Blocks',
            '${provider.twoStarMaxBlocks}',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Click "Create Level" to publish your level!',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitLevel(
    BuildContext context,
    LevelCreateProvider provider,
  ) async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) return;

    final success = await provider.createLevel(
      userId: user.id,
      context: context,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Level created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Failed to create level'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
