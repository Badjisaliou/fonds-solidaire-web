import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class DashboardService {
  static Future<int> getTotalGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/dashboard/global"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    var data = jsonDecode(response.body);

    return data["total"];
  }

  static Future<List<dynamic>> getMensuel() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/dashboard/mensuel"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return jsonDecode(response.body);
  }
}
