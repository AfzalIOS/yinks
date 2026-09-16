import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/sign_in_screen.dart';

/// Splash screen shown on app launch. Displays the YINKS name over a
/// full-screen background image and automatically navigates to the
/// Sign In screen after a short delay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image.
          Image.asset('assets/images/splash.png', fit: BoxFit.cover),

          // Subtle dark overlay so the logo text stays readable.
          Container(color: Colors.black.withValues(alpha: 0.35)),

          // YINKS name, lower-third of the screen.
          Align(
            alignment: const Alignment(0, 0.4),
            child: Text(
              'YINKS',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.background,
                letterSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
