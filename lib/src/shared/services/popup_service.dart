import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Service for displaying popup messages to users
class PopupService {
  static final PopupService _instance = PopupService._internal();

  factory PopupService() {
    return _instance;
  }

  PopupService._internal();

  /// Show success message
  static void success(
    String message, {
    BuildContext? context,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (context != null) {
      _showSnackBar(context, message, Colors.green, Icons.check_circle);
    } else {
      _showToast(message, Colors.green);
    }
  }

  /// Show error message
  static void error(
    String message, {
    BuildContext? context,
    Duration duration = const Duration(seconds: 4),
  }) {
    if (context != null) {
      _showSnackBar(context, message, Colors.red, Icons.error);
    } else {
      _showToast(message, Colors.red);
    }
  }

  /// Show warning message
  static void warning(
    String message, {
    BuildContext? context,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (context != null) {
      _showSnackBar(context, message, Colors.orange, Icons.warning);
    } else {
      _showToast(message, Colors.orange);
    }
  }

  /// Show info message
  static void info(
    String message, {
    BuildContext? context,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (context != null) {
      _showSnackBar(context, message, Colors.blue, Icons.info);
    } else {
      _showToast(message, Colors.blue);
    }
  }

  /// Show generic message
  static void message(
    String message, {
    BuildContext? context,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (context != null) {
      _showSnackBar(context, message, const Color(0xFF1A2535), null);
    } else {
      _showToast(message, const Color(0xFF1A2535));
    }
  }

  /// Show custom popup dialog
  static void customDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          backgroundColor: const Color(0xFF1A2535),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onCancel?.call();
                },
                child: Text(
                  cancelText,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm?.call();
              },
              child: Text(
                confirmText ?? 'OK',
                style: TextStyle(
                  color: confirmColor ?? Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show loading dialog
  static void loading(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A2535),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.cyan),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

  // Private helper methods

  static void _showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData? icon,
  ) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void _showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: color.withOpacity(0.9),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}