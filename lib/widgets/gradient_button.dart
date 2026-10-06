import 'package:breathify2/utils/colors.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width; // Added width parameter

  GradientButton({required this.text, required this.onPressed, this.width = 200}); // Default width = 200

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width, // Use the provided width
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF248479), Color(0xFF091C3F)], // Custom colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: AppColors.background, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}