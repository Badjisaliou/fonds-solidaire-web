import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/login"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to login: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/register"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Register failed: ${response.body}");
  }

  static Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/logout"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Logout failed: ${response.body}");
    }
  }
}
