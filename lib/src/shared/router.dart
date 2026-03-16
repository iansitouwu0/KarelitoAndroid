import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/features.dart';
import '../shared/providers/providers.dart';

class AppRouteDestination {
  const AppRouteDestination({
    required this.route,
    required this.label,
    required this.icon,
    this.child,
  });

  final String route;
  final String label;
  final Icon icon;
  final Widget? child;
}

const List<AppRouteDestination> destinations = [
  AppRouteDestination(
    label: 'Home',
    icon: Icon(Icons.arrow_right_rounded),
    route: '/',
  ),
  AppRouteDestination(
    label: 'Settings',
    icon: Icon(Icons.arrow_right_rounded),
    route: '/settings',
  ),
  AppRouteDestination(
    label: 'LevelView',
    icon: Icon(Icons.arrow_right_rounded),
    route: '/levelView',
  ),
];

final appRouter = GoRouter(
  initialLocation: '/',
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
      path:'/levelView/tutorial',
      builder:(context, state) => const LevelScreen(level: Levels.tutorial),
    ),
    GoRoute(
      path:'/levelView/nivel_1',
      builder:(context, state) => const LevelScreen(level: Levels.level1),
    ),
    GoRoute(
      path:'/levelView/nivel_2',
      builder:(context, state) => const LevelScreen(level: Levels.level2),
    ),
  ],
);