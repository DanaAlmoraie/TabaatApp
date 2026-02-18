class AuthManager {
  static String? _token;
  static Map<String, dynamic>? _user;

  static void setSession({
    required String token,
    required Map<String, dynamic> user,
  }) {
    _token = token;
    _user = user;
  }

  static String? get token => _token;
  static Map<String, dynamic>? get user => _user;

  static String get role => (_user?['role'] ?? '').toString().toLowerCase();

  static String get name => (_user?['name'] ?? '').toString();

  static void logout() {
    _token = null;
    _user = null;
  }
}
