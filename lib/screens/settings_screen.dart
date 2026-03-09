import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_background.dart';
import '../widgets/profile_card.dart';
import '../widgets/custom_buttom.dart';

import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map user = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    try {
      final data = await UserService.getUser();
      if (!mounted) return;

      setState(() {
        user = data;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  String formatDate(DateTime date) {
    final formatted = DateFormat("d MMMM yyyy", "fr_FR").format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      if (token != null && token.isNotEmpty) {
        await AuthService.logout(token);
      }
    } catch (_) {
      // Always clear local session even if remote logout fails.
    }

    await prefs.remove("token");

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final dateInscription = (user["created_at"] ?? "").toString();
    final date = dateInscription.isEmpty ? DateTime.now() : DateTime.parse(dateInscription);
    final expiration = DateTime(date.year + 1, date.month, date.day);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/logo.png", height: 30),
            const SizedBox(width: 10),
            const Text(
              "Parametres",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Carte membre",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Informations de votre adhesion",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              ProfileCard(
                name: user["name"] ?? "",
                email: user["email"] ?? "",
                inscription: formatDate(date),
                expiration: formatDate(expiration),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: "Se deconnecter",
                icon: Icons.logout,
                color: const Color(0xFFD62828),
                onPressed: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
