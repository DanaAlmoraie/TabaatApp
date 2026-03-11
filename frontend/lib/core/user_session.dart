class UserSession {
  static String? token;
  static Map<String, dynamic>? _currentUser;
  static String language = 'en';

  // ---------------- LOGIN -------------------
  static bool get isLoggedIn => _currentUser != null;

  static void startSession({
    required String userToken,
    required Map<String, dynamic> userData,
  }) {
    token = userToken;
    _currentUser = userData;
  }

  // ----------- SETTERS --------------------
  static void setUser(Map<String, dynamic> userData) {
    _currentUser = userData;
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

  // ---------------------- AVATAR ------------------
  static int get avatarIndex => _currentUser?['avatarIndex'] ?? 0;

  static void setAvatar(int index) {
    _currentUser?['avatarIndex'] = index;
  }

  // ----------------- LOGOUT -------------------
  static void logout() {
    _currentUser = null;
    token = null;
  }

  static void clear() {
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
