//import 'dart:ffi';
//import 'package:http/retry.dart';

class UserSession {
  static Map<String, dynamic>? _currentUser;
  /*
  static Map<String, dynamic> currentUser = {
    'name': 'trkrld',
    'email': 'Shopperdemo@test.com',
    'phoneNum': '0500033330',
    'role': 'shopper', // farmer | shopper
    'avatarIndex': 0,
  };
  */
  static bool get isLoggedIn => _currentUser != null;

  static void setUser(Map<String, dynamic> userData) {
    _currentUser = userData;
  }

  static Map<String, dynamic> get user {
    if (_currentUser == null) {
      throw Exception("UserSession not initialized");
    }
    return _currentUser!;
  }

  static String get role {
    if (_currentUser == null) return '';
    return (_currentUser!['role'] ?? '').toString().toLowerCase();
  }

  static String get token {
    if (_currentUser == null) return '';
    return (_currentUser!['token'] ?? '').toString();
  }

  static int get avatarIndex => _currentUser?['avatarIndex'] ?? 0;

  static void setAvatar(int index) {
    _currentUser?['avatarIndex'] = index;
  }

  static void clear() {
    _currentUser = null;
  }

  static void logout() {
    _currentUser = {};
    _currentUser?['avatarIndex'] = 0;
  }
}
