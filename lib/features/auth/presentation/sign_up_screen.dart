import 'package:flutter/material.dart';

/// Placeholder Sign Up screen used as the Sign In screen's navigation
/// target. No real sign-up UI/logic yet.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sign Up'),
      ),
    );
  }
}
