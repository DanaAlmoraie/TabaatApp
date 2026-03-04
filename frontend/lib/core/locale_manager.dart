import 'package:shared_preferences/shared_preferences.dart';

class LocaleManager {
  static const String _key = "app_language";

  // حفظ اللغة
  static Future<void> saveLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, langCode);
  }

  // قراءة اللغة
  static Future<String?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
