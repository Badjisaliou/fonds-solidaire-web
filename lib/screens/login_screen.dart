import 'package:flutter/material.dart';
import 'package:fonds_solidaire_app/screens/main_screen.dart';
import 'package:fonds_solidaire_app/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../widgets/app_background.dart';
import '../widgets/custom_buttom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  void login() async {
    setState(() {
      loading = true;
    });

    try {
      var result = await AuthService.login(
        emailController.text,
        passwordController.text,
      );

      String token = result["token"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email ou mot de passe incorrect")),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                /// LOGO
                Image.asset("assets/images/logo.png", height: 90),

                const SizedBox(height: 20),

                /// TITRE
                const Text(
                  "Fond Solidaire des Entrepreneurs",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                /// CARD FORMULAIRE
                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      /// EMAIL
                      TextField(
                        controller: emailController,

                        decoration: InputDecoration(
                          labelText: "Email",

                          prefixIcon: const Icon(Icons.email),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// PASSWORD
                      TextField(
                        controller: passwordController,
                        obscureText: true,

                        decoration: InputDecoration(
                          labelText: "Mot de passe",

                          prefixIcon: const Icon(Icons.lock),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// BOUTON LOGIN
                      if (loading)
                        const CircularProgressIndicator()
                      else
                        ...[
                          CustomButton(
                            text: "Se connecter",
                            icon: Icons.login,
                            onPressed: login,
                          ),
                          const SizedBox(height: 20),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text("Créer un compte"),
                          ),
                        ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
