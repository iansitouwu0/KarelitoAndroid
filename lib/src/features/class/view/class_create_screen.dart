import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/services.dart';
import '../../../shared/widgets/popup_helpers.dart';

class ClassCreateScreen extends StatefulWidget {
  const ClassCreateScreen({super.key});

  @override
  State<ClassCreateScreen> createState() => _ClassCreateScreenState();
}

class _ClassCreateScreenState extends State<ClassCreateScreen> {
  final _classNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  ClassVisibility _visibility = ClassVisibility.private;
  bool _isLoading = false;

  @override
  void dispose() {
    _classNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateClass() async {
    if (_classNameController.text.isEmpty) {
      PopupHelpers.showError(context, message: 'Class name cannot be empty');
      return;
    }

    if (_descriptionController.text.isEmpty) {
      PopupHelpers.showError(context, message: 'Description cannot be empty');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    PopupHelpers.showLoading(context, message: 'Creating class...');

    try {
      final classId = await ClassService.createClass(
        teacherId: user.id,
        className: _classNameController.text.trim(),
        description: _descriptionController.text.trim(),
        visibility: _visibility,
      );

      if (mounted) {
        PopupHelpers.closeLoading(context);
        PopupHelpers.showSuccess(
          context,
          message: 'Class created successfully!',
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.go('/teacher/classes');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        PopupHelpers.closeLoading(context);
        PopupHelpers.showError(context, message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: const Text(
          'Create Class',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Class Name',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _classNameController,
              decoration: InputDecoration(
                hintText: 'e.g., Computer Science 101',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.school, color: Colors.cyan),
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
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe what this class is about',
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
              'Class Type',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            _buildVisibilityOption(
              'Private Class',
              'Students join with code',
              ClassVisibility.private,
            ),
            const SizedBox(height: 12),
            _buildVisibilityOption(
              'Public Class',
              'Anyone can join',
              ClassVisibility.public,
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCreateClass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                        : const Text('Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityOption(
    String title,
    String subtitle,
    ClassVisibility visibility,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2535),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _visibility == visibility ? Colors.cyan : Colors.white24,
          width: 2,
        ),
      ),
      child: RadioListTile<ClassVisibility>(
        value: visibility,
        groupValue: _visibility,
        onChanged: (value) {
          if (value != null) {
            setState(() => _visibility = value);
          }
        },
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        activeColor: Colors.cyan,
      ),
    );
  }
}