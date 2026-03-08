import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../services/user_service.dart';
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
    var data = await UserService.getUser();

    if (!mounted) return;

    setState(() {
      user = data;
      loading = false;
    });
  }

  String formatDate(DateTime date) {
    String formatted = DateFormat("d MMMM yyyy", "fr_FR").format(date);

    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();

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

    String dateInscription = user["created_at"] ?? "";

    DateTime date = DateTime.parse(dateInscription);

    DateTime expiration = DateTime(date.year + 1, date.month, date.day);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/logo.png", height: 30),

            const SizedBox(width: 10),

            const Text(
              "Paramètres",
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
              /// TITRE
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
                "Informations de votre adhésion",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              /// PROFILE CARD
              ProfileCard(
                name: user["name"] ?? "",
                email: user["email"] ?? "",
                inscription: formatDate(date),
                expiration: formatDate(expiration),
              ),

              const SizedBox(height: 40),

              /// LOGOUT
              CustomButton(
                text: "Se déconnecter",
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
