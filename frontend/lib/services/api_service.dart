// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // مهم: هذا نفس اللي استخدمناه قبل مع المحاكي
  //static const String baseUrl = "http://10.0.2.2:8000";
  static const String baseUrl = "http://192.168.1.99:8000";

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
          "Register failed [${response.statusCode}]: ${response.body}");
    }
  }

  // ============ LOGIN ============
  static Future<String> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "username": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data["access_token"]?.toString();
      if (token == null) {
        throw Exception("Token not found in response");
      }
      return token;
    } else {
      throw Exception("Login failed [${response.statusCode}]: ${response.body}");
    }
  }

  // ============ /me ============
  static Future<Map<String, dynamic>> getMe(String token) async {
    final url = Uri.parse('$baseUrl/me');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Get /me failed [${response.statusCode}]: ${response.body}");
    }
  }
}
