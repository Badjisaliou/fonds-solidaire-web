import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final int total;
  final int objectif;

  const ProgressCard({super.key, required this.total, required this.objectif});

  @override
  Widget build(BuildContext context) {
    double progress = (total / objectif).clamp(0, 1);

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// TITRE
          const Text(
            "Objectif annuel",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5F),
            ),
          ),

          const SizedBox(height: 12),

          /// MONTANT
          Text(
            "$total / $objectif FCFA",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 16),

          /// PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: progress,

              minHeight: 12,

              backgroundColor: const Color(0xFFE9EEF4),

              valueColor: const AlwaysStoppedAnimation(
                Color(0xFFD62828), // Rouge TBH
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// POURCENTAGE
          Text(
            "${(progress * 100).toInt()}% de l'objectif atteint",

            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
