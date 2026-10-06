import 'package:flutter/material.dart';
import 'patient/patient_login_screen.dart';
import 'doctor/doctor_login_screen.dart';
import '../utils/colors.dart'; // Import colors

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}
class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String pressedRole = ""; // Track button press

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🟢 Logo & App Name at the Top
          Padding(
            padding: const EdgeInsets.only(top: 50.0), // Space from top
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo3.png', // Logo
                  height: 50,
                ),
                SizedBox(width: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "BREAT",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: AppColors.primary),
                      ),
                      TextSpan(
                        text: "HIFY!",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🟢 Centering the Doctor & Patient buttons
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Doctor Button
                  ChoiceButton(
                    image: 'assets/images/doctor.png',
                    text: "Doctor",
                    isPressed: pressedRole == "Doctor",
                    onTapDown: () {
                      setState(() {
                        pressedRole = "Doctor"; // Glow on press
                      });
                    },
                    onTapUp: () {
                      setState(() {
                        pressedRole = ""; // Remove glow on release
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorLoginScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 30), // Space between buttons
                  // Patient Button
                  ChoiceButton(
                    image: 'assets/images/patient.png',
                    text: "Patient",
                    isPressed: pressedRole == "Patient",
                    onTapDown: () {
                      setState(() {
                        pressedRole = "Patient"; // Glow on press
                      });
                    },
                    onTapUp: () {
                      setState(() {
                        pressedRole = ""; // Remove glow on release
                      });
                      // Navigate to LoginScreen when Patient is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PatientLoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🟢 Choice Button Widget
class ChoiceButton extends StatelessWidget {
  final String image;
  final String text;
  final bool isPressed;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;

  ChoiceButton({
    required this.image,
    required this.text,
    required this.isPressed,
    required this.onTapDown,
    required this.onTapUp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(), // Start glow
      onTapUp: (_) => onTapUp(), // Remove glow
      onTapCancel: onTapUp, // Ensure glow disappears if touch is canceled
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100), // Fast transition
        width: 160, // Adjusted width
        height: 180, // Adjusted height
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isPressed
              ? [
            BoxShadow(
              color: AppColors.glow.withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 6,
            ),
          ]
              : [], // Glow only when pressed
          border: Border.all(
            color: AppColors.grey,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 80), // Adjusted image size
            SizedBox(height: 10),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}