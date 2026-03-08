import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CotisationCard extends StatelessWidget {
  final Map cotisation;

  const CotisationCard({super.key, required this.cotisation});

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);

    String formatted = DateFormat("d MMMM yyyy", "fr_FR").format(parsedDate);

    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),

      padding: const EdgeInsets.all(16),

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

      child: Row(
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: const Color(0xFF1E3A5F).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.payments,
              color: Color(0xFF1E3A5F),
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// MONTANT
                Text(
                  "${cotisation["montant"]} FCFA",

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),

                const SizedBox(height: 4),

                /// DESCRIPTION
                if (cotisation["description"] != null &&
                    cotisation["description"].toString().isNotEmpty)
                  Text(
                    cotisation["description"],

                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                const SizedBox(height: 6),

                /// DATE
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 14,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      formatDate(cotisation["date_cotisation"]),

                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
