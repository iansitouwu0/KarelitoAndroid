import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../shared/views/views.dart';
import '../../../shared/controllers/controllers.dart';
import '../../../shared/providers/providers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bt = context.watch<BluetoothManager>(); 

    return AdaptativeScreen(
      appbar:AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  authProvider.signOut();
                  context.go('/signin');
                },
              );
            },
          ),
        ],
      ),
      backgroundImage: 'assets/home/homeBg.jpg',
      titleImage: 'assets/home/homeTitle.png',
      height: height,
      children: [
      
        Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2535),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${user.username}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Account: ${user.role.name.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Menu Options
                SizedBox(
                  width: height * 0.45,
                  child: ElevatedButton(
                    onPressed: () => context.go('/levelView'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: height * 0.03),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: TextStyle(
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Jugar'),
                  ),
                ),
                const SizedBox(height: 16),

                // Available to all users
                _buildMenuButton(
                  title: 'Crea Nivel',
                  description: 'Crea Un Nivel Nuevo',
                  icon: Icons.create_rounded,
                  onTap: () => context.go('/level/create'),
                ),
                const SizedBox(height: 12),

                // Available to teachers
                if (authProvider.isTeacher) ...[
                  _buildMenuButton(
                    title: 'Crear Clase',
                    description: 'Crea Una Nueva Clase Para Tus Alumnos',
                    icon: Icons.school_rounded,
                    onTap: () => context.go('/class/create'),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    title: 'Mis Clases',
                    description: 'Controla Tus Clases Y Tareas',
                    icon: Icons.dashboard_rounded,
                    onTap: () => context.go('/teacher/classes'),
                  ),
                  const SizedBox(height: 12),
                ],

                // Available to students
                if (authProvider.isStudent) ...[
                  _buildMenuButton(
                    title: 'Unirse a Clase',
                    description: 'Unete a Una Clase Usando El Código de Maestro ',
                    icon: Icons.group_add_rounded,
                    onTap: () => context.go('/student/join-class'),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    title: 'Mis Clases',
                    description: 'Ve Tus Clases y Tareas',
                    icon: Icons.assignment_rounded,
                    onTap: () => context.go('/student/classes'),
                  ),
                  const SizedBox(height: 12),
                ],

                // Available to all authenticated users
                _buildMenuButton(
                  title: 'Explorar Niveles',
                  description: 'Juega Niveles Públicos',
                  icon: Icons.explore_rounded,
                  onTap: () => context.go('/levels'),
                ),
                const SizedBox(height: 12),

                _buildMenuButton(
                  title: 'Mis Niveles',
                  description: 'Mira y Edita Niveles Que Has Creado',
                  icon: Icons.library_books_rounded,
                  onTap: () => context.go('/my-levels'),
                ),
              ],
            ),
          );
        },
      ),

        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: height * 0.07,
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () => context.go('/settings'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        bt.isConnected
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth_disabled,
                        color: bt.isConnected ? Colors.greenAccent : Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        bt.isConnected ? 'Conectado' : 'Sin conexión',
                        style: TextStyle(
                          color: bt.isConnected ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildMenuButton({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2535),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.cyan, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white38,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}