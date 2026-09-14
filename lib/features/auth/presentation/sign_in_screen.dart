import 'package:flutter/material.dart';

/// Placeholder Sign In screen used as the splash screen's navigation
/// target. No real sign-in UI/logic yet.
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sign In'),
      ),
    );
  }
}
