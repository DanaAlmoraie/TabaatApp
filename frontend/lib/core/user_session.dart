import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static String? token;
  static Map<String, dynamic>? _currentUser;
  static String language = 'en';

  static int avatarIndex = 0;

  static bool locationEnabled = true;
  static bool cameraEnabled = true;

  static void startSession({
    required String userToken,
    required Map<String, dynamic> userData,
  }) async {
    token = userToken;
    UserSession._currentUser = userData;

    final prefs = await SharedPreferences.getInstance();

    cameraEnabled = prefs.getBool('cameraEnabled') ?? true;
    locationEnabled = prefs.getBool('locationEnabled') ?? true;
    avatarIndex = prefs.getInt('avatarIndex') ?? 0;
  }

  // ----------- SETTERS --------------------
  static void setUser(Map<String, dynamic> userData) {
    _currentUser = userData;
  }

  static Future<void> setCameraPermission(bool value) async {
    cameraEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cameraEnabled', value);
  }

  static Future<void> setLocationPermission(bool value) async {
    locationEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationEnabled', value);
  }

  static Future<void> setAvatar(int index) async {
    avatarIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('avatarIndex', index);
    //_currentUser?['avatarIndex'] = index;
  }

  // ---------------- GETTERS ---------------

  static String get name => user['name'] ?? '';
  static String get email => user['email'] ?? '';
  static String get role {
    if (_currentUser == null) return '';
    return (_currentUser!['role'] ?? '').toString().toLowerCase();
  }

  static Map<String, dynamic> get user {
    if (_currentUser == null) {
      throw Exception("UserSession not initialized");
    }
    return _currentUser!;
  }

  // ---------------- LOGIN -------------------
  static bool get isLoggedIn => _currentUser != null;

  // ----------------- LOGOUT -------------------
  static void logout() {
    _currentUser = null;
    token = null;
  }

  static void clear() {
    token = null;
    _currentUser = null;
  }

  // ---------------- UPDATE ------------------
  static void updateUser(Map<String, dynamic> newData) {
    _currentUser = newData;
  }

  // --------------- LANGUAGE -----------------
  static void changeLanguage(String lang) {
    language = lang;
  }
}
