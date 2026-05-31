import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/services.dart';

class MyLevelsScreen extends StatefulWidget {
  const MyLevelsScreen({super.key});

  @override
  State<MyLevelsScreen> createState() => _MyLevelsScreenState();
}

class _MyLevelsScreenState extends State<MyLevelsScreen> {
  late Future<List<LevelModel>> _levelsFuture;

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthProvider>().currentUser?.id ?? '';
    _levelsFuture = LevelService.getUserLevels(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: const Text(
          'My Levels',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<LevelModel>>(
        future: _levelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 48, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  const Text(
                    'No levels created yet',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/level/create'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Level'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
                  ),
                ],
              ),
            );
          }

          final levels = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final level = levels[index];
              return _buildLevelCard(context, level);
            },
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, LevelModel level) {
    return GestureDetector(
      onTap: () => context.push('/level/${level.id}'),
      child: Card(
        color: const Color(0xFF1A2535),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                level.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                level.description,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      level.difficulty.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Text(
                    '${level.map.width}×${level.map.height}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}