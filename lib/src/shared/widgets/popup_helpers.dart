import 'package:flutter/material.dart';
import 'custom_popup.dart';

/// Helper functions for easy popup usage
class PopupHelpers {
  /// Show success popup
  static void showSuccess(
    BuildContext context, {
    required String message,
    String title = 'Success',
    Duration duration = const Duration(seconds: 3),
  }) {
    showCustomPopup(
      context,
      title: title,
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      backgroundColor: const Color(0xFF1A2535),
      duration: duration,
    );
  }

  /// Show error popup
  static void showError(
    BuildContext context, {
    required String message,
    String title = 'Error',
    Duration duration = const Duration(seconds: 4),
  }) {
    showCustomPopup(
      context,
      title: title,
      message: message,
      icon: Icons.error,
      iconColor: Colors.red,
      backgroundColor: const Color(0xFF1A2535),
      duration: duration,
    );
  }

  /// Show warning popup
  static void showWarning(
    BuildContext context, {
    required String message,
    String title = 'Warning',
    Duration duration = const Duration(seconds: 3),
  }) {
    showCustomPopup(
      context,
      title: title,
      message: message,
      icon: Icons.warning,
      iconColor: Colors.orange,
      backgroundColor: const Color(0xFF1A2535),
      duration: duration,
    );
  }

  /// Show info popup
  static void showInfo(
    BuildContext context, {
    required String message,
    String title = 'Info',
    Duration duration = const Duration(seconds: 3),
  }) {
    showCustomPopup(
      context,
      title: title,
      message: message,
      icon: Icons.info,
      iconColor: Colors.blue,
      backgroundColor: const Color(0xFF1A2535),
      duration: duration,
    );
  }

  /// Show loading dialog
  static void showLoading(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A2535),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Close loading dialog
  static void closeLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A2535),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                cancelText,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                confirmText,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}