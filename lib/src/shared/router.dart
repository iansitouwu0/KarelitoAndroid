import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../features/features.dart';
import '../shared/providers/providers.dart';
import '../shared/models/models.dart';

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
    final userRole = authProvider.currentUser?.role;
    // Redirect unauthenticated users
    if (!isAuth &&
        !state.matchedLocation.startsWith('/signin') &&
        !state.matchedLocation.startsWith('/signup') &&
        !state.matchedLocation.startsWith('/splash')) {
      return '/signin';
    }

    if (isAuth &&
        (state.matchedLocation.startsWith('/signin') ||
            state.matchedLocation.startsWith('/signup'))) {
      return '/home';
    }

  if (userRole == UserRole.teacher &&
      state.matchedLocation.startsWith('/student/')) {
    return '/teacher/classes';
  }

  if (userRole == UserRole.student &&
      state.matchedLocation.startsWith('/teacher/')) {
    return '/student/classes';
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
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
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
      path: '/level/create',
      builder: (context, state) => const LevelCreateScreen(),
    ),
    GoRoute(
      path: '/level/:levelId',
      builder: (context, state) {
        final levelId = state.pathParameters['levelId'] ?? '';
        return LevelDetailScreen(levelId: levelId);
      },
    ),
    GoRoute(
      path: '/my-levels',
      builder: (context, state) => const MyLevelsScreen(),
    ),
    GoRoute(
      path: '/browse-levels',
      builder: (context, state) => const BrowseLevelsScreen(),
    ),

    GoRoute(
      path: '/class/create',
      builder: (context, state) => const ClassCreateScreen(),
    ),
    GoRoute(
      path: '/teacher/classes',
      builder: (context, state) => const TeacherClassesScreen(),
    ),
    GoRoute(
      path: '/class/:classId',
      builder: (context, state) {
        final classId = state.pathParameters['classId'] ?? '';
        return TeacherClassDetailScreen(classId: classId);
      },
    ),

    GoRoute(
      path: '/student/classes',
      builder: (context, state) => const StudentClassesScreen(),
    ),
    GoRoute(
      path: '/student/class/:classId',
      builder: (context, state) {
        final classId = state.pathParameters['classId'] ?? '';
        return StudentClassDetailScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/student/join',
      builder: (context, state) => const JoinClassScreen(),
    ),

    GoRoute(
      path: '/homework/:homeworkId',
      builder: (context, state) {
        final homeworkId = state.pathParameters['homeworkId'] ?? '';
        return HomeworkDetailScreen(homeworkId: homeworkId);
      },
    ),
    GoRoute(
      path: '/homework/create/:classId',
      builder: (context, state) {
        final classId = state.pathParameters['classId'] ?? '';
        return HomeworkCreateScreen(classId: classId);
      },
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

void navigateToLevel(BuildContext context, String levelId) {
  context.go('/level/$levelId');
}

void createLevel(BuildContext context) {
  context.push('/level/create');
}

void viewMyLevels(BuildContext context) {
  context.push('/my-levels');
}

void joinClass(BuildContext context) {
  context.push('/student/join');
}

void viewClassDetails(BuildContext context, String classId) {
  context.push('/student/class/$classId');
}

void createHomework(BuildContext context, String classId) {
  context.push('/homework/create/$classId');
}

// Pop back to previous screen
void goBack(BuildContext context) {
  context.pop();
}