import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Gradient principal TBH
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5F7FA), Color(0xFFE9EEF4)],

              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        /// Logo watermark
        Center(
          child: Opacity(
            opacity: 0.04,

            child: Image.asset("assets/images/logo.png", width: 260),
          ),
        ),

        /// léger dégradé supérieur (style fintech)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x221E3A5F), Colors.transparent],

              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
        ),

        /// Contenu de l'écran
        SafeArea(child: child),
      ],
    );
  }
}
