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
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/register"),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },

      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur inscription");
    }
  }
}
