import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../features/features.dart';
import '../shared/providers/providers.dart';

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

String? _levelIdFromPath(String path) {
  const map = {
    '/levelView/tutorial': 'tutorial',
    '/levelView/nivel_1': 'nivel_1',
    '/levelView/nivel_2': 'nivel_2',
  };
  return map[path];
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAuth = authProvider.isLoggedIn;

    // Redirect unauthenticated users
    if (!isAuth &&
        !state.matchedLocation.startsWith('/signin') &&
        !state.matchedLocation.startsWith('/signup') &&
        !state.matchedLocation.startsWith('/splash')) {
      return '/signin';
    }

    // Redirect authenticated users away from auth screens
    if (isAuth &&
        (state.matchedLocation.startsWith('/signin') ||
            state.matchedLocation.startsWith('/signup'))) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path:'/splash',
      builder: (context , state) => const SplashScreen(),
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
