import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class DashboardService {
  static Future<int> getTotalGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/dashboard/global"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur dashboard global: ${response.body}");
    }

    final data = jsonDecode(response.body);
    return int.tryParse(data["total"].toString()) ?? 0;
  }

  static Future<List<dynamic>> getMensuel() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/dashboard/mensuel"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur dashboard mensuel: ${response.body}");
    }

    return jsonDecode(response.body) as List<dynamic>;
  }
}
