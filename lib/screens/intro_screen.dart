import 'package:breathify2/widgets/gradient_button.dart';
import 'role_selection_screen.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart'; // Import colors

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Full Image at the Top
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/intro_image.png',
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          // Center Text & Button Vertically Under the Image
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title with RichText
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
                SizedBox(height: 10),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Discover a new way to breathe and relax with our guided exercises.",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.secondary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Button at the Bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: GradientButton(
              text: "Start",
              width: 180,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
