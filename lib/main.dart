import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('fr_FR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Teranga Business Hub",

      /// langues supportées
      supportedLocales: const [Locale('fr', 'FR')],

      /// localisation Flutter
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      locale: const Locale('fr', 'FR'),

      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A5F),

        scaffoldBackgroundColor: const Color(0xFFF5F7FA),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A5F),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1E3A5F),
          secondary: Color(0xFFD62828),
        ),
      ),

      home: const LoginScreen(),
    );
  }
}
