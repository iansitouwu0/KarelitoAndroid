import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/features.dart';
import '../shared/providers/providers.dart';
import '../shared/providers/progress_manager.dart';

class AppRouteDestination {
  const AppRouteDestination({
    required this.route,
    required this.label,
    required this.icon,
  });

  final String route;
  final String label;
  final Icon icon;
}

const List<AppRouteDestination> destinations = [
  AppRouteDestination(
    label: 'Home',
    icon: Icon(Icons.home_rounded),
    route: '/',
  ),
  AppRouteDestination(
    label: 'Settings',
    icon: Icon(Icons.settings_rounded),
    route: '/settings',
  ),
  AppRouteDestination(
    label: 'Niveles',
    icon: Icon(Icons.grid_view_rounded),
    route: '/levelView',
  ),
];

/// Devuelve el id del nivel a partir de la ruta, o null si no aplica.
String? _levelIdFromPath(String path) {
  const map = {
    '/levelView/tutorial': 'tutorial',
    '/levelView/nivel_1': 'nivel_1',
    '/levelView/nivel_2': 'nivel_2',
  };
  return map[path];
}

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final levelId = _levelIdFromPath(state.matchedLocation);
    if (levelId != null) {
      final progress = ProgressManager();
      if (!progress.isUnlocked(levelId)) {
        // Nivel bloqueado → redirige a la pantalla de niveles
        return '/levelView';
      }
    }
    return null; // sin redirección
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/levelView',
      builder: (context, state) => const NivelesScreen(),
    ),
    GoRoute(
      path: '/settings/bluetooth',
      builder: (context, state) => const ConnectionScreen(),
    ),
    GoRoute(
      path: '/levelView/tutorial',
      builder: (context, state) => const LevelScreen(level: Levels.tutorial),
    ),
    GoRoute(
      path: '/levelView/nivel_1',
      builder: (context, state) => const LevelScreen(level: Levels.level1),
    ),
    GoRoute(
      path: '/levelView/nivel_2',
      builder: (context, state) => const LevelScreen(level: Levels.level2),
    ),
  ],
);
