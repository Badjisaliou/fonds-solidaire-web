import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class UserService {
  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/user"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return jsonDecode(response.body);
  }
}
