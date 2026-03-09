import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class CotisationService {
  static Future<List<dynamic>> getCotisations({int? month}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    String url = "${ApiConfig.baseUrl}/cotisations";
    if (month != null) {
      url += "?month=$month";
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur API cotisations: ${response.body}");
    }

    final data = jsonDecode(response.body);
    return data["data"] ?? [];
  }

  static Future<void> addCotisation(
    String montant,
    String description,
    Uint8List fileBytes,
    String fileName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${ApiConfig.baseUrl}/cotisations"),
    );

    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    request.fields["montant"] = montant;
    request.fields["description"] = description;
    request.fields["date_cotisation"] = DateTime.now().toIso8601String().split("T").first;

    request.files.add(
      http.MultipartFile.fromBytes(
        "justificatif",
        fileBytes,
        filename: fileName,
      ),
    );

    final response = await request.send();
    if (response.statusCode != 201) {
      final body = await response.stream.bytesToString();
      throw Exception("Erreur creation cotisation: $body");
    }
  }

  static Future<int> getTotalUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/cotisations/total-user"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur recuperation total: ${response.body}");
    }

    final data = jsonDecode(response.body);
    return int.tryParse(data["total"].toString()) ?? 0;
  }
}
