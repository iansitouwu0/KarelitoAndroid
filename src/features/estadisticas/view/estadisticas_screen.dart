import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../shared/providers/niveles_data.dart';
import '../../../shared/providers/progress_manager.dart';

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  String _performanceLabel(double averageStars) {
    if (averageStars >= 2.7) return 'Excelente rendimiento';
    if (averageStars >= 2.0) return 'Buen rendimiento';
    if (averageStars > 0) return 'Práctica recomendada';
    return 'Aún no hay datos';
  }

  String _levelStatus(int stars) {
    if (stars == 0) return 'Pendiente';
    if (stars == 3) return 'Excelente';
    if (stars == 2) return 'Bien';
    return 'Puede mejorar';
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressManager>();
    final totalLevels = ProgressManager.levelOrder.length;
    final completedLevels = progress.levelsCompleted;
    final averageStars = progress.averageStars;
    final totalStars = progress.totalStars;
    final totalRuns = progress.totalRunAttempts;
    final completionRate = totalLevels == 0 ? 0 : (completedLevels * 100 ~/ totalLevels);
    final maxBlocks = Levels.all
        .map((level) => progress.getBestBlocks(level.id))
        .fold<int>(1, (previous, value) => value > previous ? value : previous);
    final aggregatedBlockTypes = _aggregateBlockTypeCounts(progress);
    final aggregatedCollisions = Levels.all
      .map((level) => progress.getCollisionAttempts(level.id))
      .fold<int>(0, (sum, v) => sum + v);
    final aggregatedNonCompletions = Levels.all
      .map((level) => progress.getNonCompletionAttempts(level.id))
      .fold<int>(0, (sum, v) => sum + v);
    final maxBlockTypeCount = aggregatedBlockTypes.values.fold<int>(0, (prev, value) => value > prev ? value : prev);
    final cognitiveSkillScores = _calculateCognitiveSkillScores(progress, aggregatedBlockTypes, aggregatedCollisions, aggregatedNonCompletions, totalRuns);
    final topCognitiveSkill = cognitiveSkillScores.entries.isNotEmpty
        ? cognitiveSkillScores.entries.reduce((a, b) => a.value >= b.value ? a : b).key
        : 'Sin datos';
    final bottomCognitiveSkill = cognitiveSkillScores.entries.isNotEmpty
        ? cognitiveSkillScores.entries.reduce((a, b) => a.value <= b.value ? a : b).key
        : 'Sin datos';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          height: kToolbarHeight,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Estadísticas del jugador',
                  
                  style: TextStyle(color: Color.fromARGB(255, 255, 111, 101), fontSize: 21, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Análisis de rendimiento y habilidades cognitivas',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color(0xFF0F1923),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home/homeBg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
          color: Color(0xFF08101A),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Panel de estadísticas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aquí puedes revisar tu progreso, análisis IA y el desarrollo de tus habilidades cognitivas.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                title: 'Resumen general',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow('Niveles completados', '$completedLevels / $totalLevels'),
                    _buildSummaryRow('Estrellas obtenidas', '$totalStars'),
                    _buildSummaryRow('Puntos acumulados', '${progress.totalScore}'),
                    _buildSummaryRow('Promedio de estrellas', averageStars.toStringAsFixed(2)),
                    _buildSummaryRow('Ejecutados (run)', '$totalRuns'),
                    _buildSummaryRow('Intentos con choque', '$aggregatedCollisions'),
                    _buildSummaryRow('Intentos fallidos (no completado)', '$aggregatedNonCompletions'),
                    _buildSummaryRow('Progreso de niveles', '$completionRate%'),
                    const SizedBox(height: 8),
                    Text(
                      _performanceLabel(averageStars),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _buildChartCard(
                title: 'Gráfica de rendimiento por nivel',
                child: Column(
                  children: Levels.all.map((level) {
                    final stars = progress.getStars(level.id);
                    final blocks = progress.getBestBlocks(level.id);
                    final barWidth = maxBlocks == 0 ? 0.0 : blocks / maxBlocks;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                level.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '$blocks bloques',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Stack(
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: barWidth.clamp(0.0, 1.0),
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: List.generate(3, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(
                                  index < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: index < stars ? Colors.amberAccent : Colors.white24,
                                  size: 16,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Rendimiento por nivel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...Levels.all.map((level) {
                final stars = progress.getStars(level.id);
                final blocks = progress.getBestBlocks(level.id);
                final blockTypes = progress.getBlockTypeCounts(level.id);
                final totalBlockTypes = blockTypes.values.fold<int>(0, (sum, value) => sum + value);
                final played = stars > 0;
                final collisions = progress.getCollisionAttempts(level.id);
                final nonCompletions = progress.getNonCompletionAttempts(level.id);
                final bestTimeMs = progress.getBestTime(level.id);
                final levelScore = progress.getLevelScore(level.id);
                return _buildLevelCard(
                  levelTitle: level.title,
                  stars: stars,
                  blocks: blocks,
                  runs: progress.getRunAttempts(level.id),
                  blockTypes: blockTypes,
                  totalBlockTypes: totalBlockTypes,
                  collisionAttempts: collisions,
                  nonCompletionAttempts: nonCompletions,
                  bestTimeMs: bestTimeMs,
                  levelScore: levelScore,
                  status: _levelStatus(stars),
                  note: played
                      ? 'Mejor uso: ${blocks > 0 ? '$blocks bloques' : 'sin registro de bloques'}'
                      : 'No completado aún',
                );
              }).toList(),
              const SizedBox(height: 24),
              
              _buildChartCard(
                title: 'Gráfico de bloques por tipo',
                child: Column(
                  children: aggregatedBlockTypes.entries.map((entry) {
                    final count = entry.value;
                    final widthFactor = maxBlockTypeCount == 0 ? 0.0 : count / maxBlockTypeCount;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: widthFactor.clamp(0.0, 1.0),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
              _buildAnalysisCard(progress, aggregatedBlockTypes, aggregatedCollisions, aggregatedNonCompletions, totalRuns),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Regresar'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF142037),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF142037),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required String levelTitle,
    required int stars,
    required int blocks,
    required int runs,
    required Map<String, int> blockTypes,
    required int totalBlockTypes,
    required int collisionAttempts,
    required int nonCompletionAttempts,
    required int bestTimeMs,
    required int levelScore,
    required String status,
    required String note,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111A27),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                levelTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: stars == 3
                      ? Colors.greenAccent
                      : stars == 2
                          ? Colors.lightGreenAccent
                          : stars == 1
                              ? Colors.orangeAccent
                              : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  index < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: index < stars ? Colors.amberAccent : Colors.white24,
                  size: 20,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            note,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          if (stars > 0) ...[
            const SizedBox(height: 6),
            Text(
              'Bloques usados: ${blocks > 0 ? blocks : 'No registrado'}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total bloques por tipo: $totalBlockTypes',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Bloques por tipo:',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: blockTypes.entries.map((entry) {
                return Text(
                  '${entry.key}: ${entry.value}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ],
          if (runs > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Intentos run: $runs',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
          if (bestTimeMs > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Mejor tiempo: ${_formatTime(bestTimeMs)}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
          if (levelScore > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Puntos máximos: $levelScore',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (collisionAttempts > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Intentos con choque: $collisionAttempts',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
          if (nonCompletionAttempts > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Intentos fallidos: $nonCompletionAttempts',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Map<String, int> _aggregateBlockTypeCounts(ProgressManager progress) {
    final totals = {
      'Avanzar': 0,
      'Giro Izq.': 0,
      'Giro Der.': 0,
      'Sensor': 0,
      'Repetir': 0,
      'Función': 0,
    };

    for (final level in Levels.all) {
      final counts = progress.getBlockTypeCounts(level.id);
      counts.forEach((key, value) {
        totals[key] = (totals[key] ?? 0) + value;
      });
    }

    return totals;
  }

  Map<String, double> _calculateCognitiveSkillScores(
    ProgressManager progress,
    Map<String, int> aggregatedBlockTypes,
    int collisions,
    int nonCompletions,
    int totalRuns,
  ) {
    final totalBlocks = aggregatedBlockTypes.values.fold<int>(0, (sum, value) => sum + value);
    final loops = aggregatedBlockTypes['Repetir'] ?? 0;
    final functions = aggregatedBlockTypes['Función'] ?? 0;
    final sensors = aggregatedBlockTypes['Sensor'] ?? 0;
    final avgStarsRatio = progress.averageStars / 3.0;
    final collisionRate = totalRuns == 0 ? 0.0 : collisions / totalRuns;
    final failureRate = totalRuns == 0 ? 0.0 : nonCompletions / totalRuns;
    final structureRatio = totalBlocks == 0 ? 0.0 : (loops + functions) / totalBlocks;
    final sensorRatio = totalBlocks == 0 ? 0.0 : sensors / totalBlocks;
    final completionRatio = progress.levelsCompleted / ProgressManager.levelOrder.length;

    final algorithmic = _clampDouble(
      avgStarsRatio * 0.35 + structureRatio * 0.35 + (1 - failureRate) * 0.3,
      0,
      1,
    );
    final abstract = _clampDouble(
      structureRatio * 0.45 + avgStarsRatio * 0.25 + completionRatio * 0.3,
      0,
      1,
    );
    final logical = _clampDouble(
      avgStarsRatio * 0.4 + sensorRatio * 0.2 + (1 - collisionRate) * 0.4,
      0,
      1,
    );
    final perceptual = _clampDouble(
      sensorRatio * 0.45 + (1 - collisionRate) * 0.3 + completionRatio * 0.25,
      0,
      1,
    );

    return {
      'Pensamiento algorítmico': algorithmic * 100,
      'Pensamiento abstracto': abstract * 100,
      'Razonamiento lógico': logical * 100,
      'Percepción perceptual': perceptual * 100,
    };
  }

  double _clampDouble(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  String _formatTime(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildAnalysisCard(ProgressManager progress, Map<String, int> aggregatedBlockTypes, int collisions, int nonCompletions, int totalRuns) {
    final analysis = _generateAnalysis(progress, aggregatedBlockTypes, collisions, nonCompletions, totalRuns);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF142037),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Análisis automático',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            analysis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _generateAnalysis(ProgressManager progress, Map<String, int> aggregatedBlockTypes, int collisions, int nonCompletions, int totalRuns) {
    final buffer = StringBuffer();

    final avg = progress.averageStars;
    buffer.writeln('Resumen:');
    if (progress.levelsCompleted == 0) {
      buffer.writeln('- Aún no hay niveles completados. Empieza por completar el tutorial.');
      return buffer.toString();
    }

    buffer.writeln('- Niveles completados: ${progress.levelsCompleted}');
    buffer.writeln('- Promedio de estrellas: ${avg.toStringAsFixed(2)}');

    final skillScores = _calculateCognitiveSkillScores(progress, aggregatedBlockTypes, collisions, nonCompletions, totalRuns);
    final mostDeveloped = skillScores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    final needsImprovement = skillScores.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
    buffer.writeln('\nDe acuerdo con el análisis IA:');
    buffer.writeln('- Inteligencia más desarrollada: $mostDeveloped.');
    buffer.writeln('- Área con más potencial de mejora: $needsImprovement.');

    // Skills estimation
    final totalBlocksUsed = aggregatedBlockTypes.values.fold<int>(0, (s, v) => s + v);
    final loops = aggregatedBlockTypes['Repetir'] ?? 0;
    final functions = aggregatedBlockTypes['Función'] ?? 0;
    final sensors = aggregatedBlockTypes['Sensor'] ?? 0;

    buffer.writeln('\nHabilidades adquiridas:');
    if (avg >= 2.0) {
      buffer.writeln('- Buen dominio de conceptos básicos de movimiento y resolución de niveles.');
    } else {
      buffer.writeln('- Está desarrollando fundamentos de control secuencial y pensamiento paso a paso.');
    }

    if (loops + functions > 0) {
      buffer.writeln('- Uso de abstracción: puedes estructurar soluciones usando ${loops > 0 ? 'bucles' : ''}${(loops > 0 && functions > 0) ? ' y ' : ''}${functions > 0 ? 'funciones' : ''}.');
    }

    if (sensors > 0) {
      buffer.writeln('- Condicionales y sensado: has utilizado sensores para decisiones en tiempo de ejecución.');
    }

    buffer.writeln('\nÁreas a mejorar:');
    // collision and failures suggestions
    if (totalRuns > 0) {
      final collisionRate = collisions / totalRuns;
      final failureRate = nonCompletions / totalRuns;
      if (collisionRate > 0.2) {
        buffer.writeln('- Muchos choques (rate ${(collisionRate * 100).toStringAsFixed(0)}%). Practica verificar pasos y simular antes de ejecutar.');
      }
      if (failureRate > 0.2) {
        buffer.writeln('- Alto número de ejecuciones que no completan (rate ${(failureRate * 100).toStringAsFixed(0)}%). Mejora planificación del algoritmo y validación por partes.');
      }
    }

    if (totalBlocksUsed > 0) {
      final loopRatio = loops / totalBlocksUsed;
      final funcRatio = functions / totalBlocksUsed;
      if (loopRatio < 0.08) {
        buffer.writeln('- Usa más bucles para reducir repeticiones y pensar en patrones.');
      }
      if (funcRatio < 0.05) {
        buffer.writeln('- Considera usar funciones para abstraer pasos repetidos y mejorar modularidad.');
      }
    }

    buffer.writeln('\nSugerencias prácticas:');
    buffer.writeln('- Planifica la solución en papel antes de codificar.');
    buffer.writeln('- Prueba con casos pequeños y verifica movimientos paso a paso.');
    buffer.writeln('- Extrae subrutinas cuando repitas secuencias (funciones).');
    buffer.writeln('- Añade bucles cuando repitas patrones, y usa sensores para decisiones condicionales.');

    return buffer.toString();
  }
}

