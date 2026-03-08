import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String inscription;
  final String expiration;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.inscription,
    required this.expiration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF2F4F7F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// LOGO + ORGANISATION
          Row(
            children: [
              Image.asset("assets/images/logo.png", height: 42),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  "Fond Solidaire des Entrepreneurs",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// NOM UTILISATEUR
          Text(
            name,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          /// EMAIL
          Text(
            email,

            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 24),

          /// DATES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Inscription",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    inscription,

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Expiration",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    expiration,

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
