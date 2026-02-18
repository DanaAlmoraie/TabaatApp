// lib/services/api_service.dart
import 'dart:convert';
import 'package:frontend/core/user_session.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000',
  );
  // ============ REGISTER ============
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    bool shareLocation = false,
    double? latitude,
    double? longitude,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      // backend عندك يستقبل location كـ نص ، فلو بنرسل GPS نخزّنه كنص
      if (shareLocation && latitude != null && longitude != null)
        "location": "$latitude,$longitude",
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // هنا نرجّع Map حقيقية عشان ما يطيح عند userJson['role']
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        "Register failed [${response.statusCode}]: ${response.body}",
      );
    }
  }

  // ============ LOGIN ============
  static Future<String> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"username": email, "password": password},
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Login failed [${response.statusCode}]: ${response.body}",
      );
    }
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data['access_token'];
  }

  // ============ /GET ME ============
  static Future<Map<String, dynamic>> getMe(String token) async {
    final url = Uri.parse("$baseUrl/me");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Get /me failed [${response.statusCode}]: ${response.body}",
      );
    }
  }

  // ================= UPDATE USER PROFILE =================
  static Future<Map<String, dynamic>> updateUserProfile({
    required String name,
    required String email,
    String? password, // اختياري
    required String token, // لتوثيق المستخدم
  }) async {
    final url = Uri.parse('$baseUrl/me');

    final Map<String, dynamic> body = {
      "name": name,
      "email": email,
      if (password != null && password.isNotEmpty) "password": password,
    };

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        "Update profile failed [${response.statusCode}]: ${response.body}",
      );
    }
  }

  // ========================== ADD FARM (To: Farmer) ====================
  static Future<void> addFarm({
    required String name,
    required String location,
    required List<String> fruits,
    required bool isArchived,
  }) async {
    final token = UserSession.user['token'];

    final url = Uri.parse("$baseUrl/farms");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "location": location,
        "fruits": fruits,
        "is_archived": isArchived,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Add farm failed: ${response.body}");
    }
  }

  static Future<List<dynamic>> getMyFarms() async {
    final token = UserSession.user['token'];

    final url = Uri.parse("$baseUrl/farms/me");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load my farms: ${response.body}");
    }
  }

  static Future<void> deleteFarm(int farmId) async {
    final token = UserSession.user['token'];

    final url = Uri.parse("$baseUrl/farms/$farmId");

    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete farm");
    }
  }

  // ======================= SHOW FARM (To: SHOPPER) ================
  static Future<List<dynamic>> getAllFarms() async {
    final token = UserSession.user['token'];

    final url = Uri.parse("$baseUrl/farms");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load farms: ${response.body}");
    }
  }
}
