import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFD62828), // rouge TBH
          foregroundColor: Colors.white,

          padding: const EdgeInsets.symmetric(vertical: 16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          elevation: 4,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],

            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
