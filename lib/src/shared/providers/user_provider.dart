import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  
  final Map<String, UserModel> _usersCache = {};

  // Get user data (with caching)
  Future<UserModel?> getUserById(String userId) async {
    // Check cache first
    if (_usersCache.containsKey(userId)) {
      return _usersCache[userId];
    }

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      final user = UserModel.fromFirestore(doc);
      _usersCache[userId] = user;
      return user;
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String userId,
    String? username,
    String? profilePicture,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        if (username != null) 'username': username,
        if (profilePicture != null) 'profilePicture': profilePicture,
        'updatedAt': Timestamp.now(),
      });

      // Update cache
      if (_usersCache.containsKey(userId)) {
        final user = _usersCache[userId]!;
        _usersCache[userId] = UserModel(
          id: user.id,
          email: user.email,
          username: username ?? user.username,
          role: user.role,
          profilePicture: profilePicture ?? user.profilePicture,
          createdAt: user.createdAt,
          updatedAt: DateTime.now(),
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  // Clear cache
  void clearCache() {
    _usersCache.clear();
  }
}