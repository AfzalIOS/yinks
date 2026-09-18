import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// My Applications root tab. Placeholder — built out in a later task.
/// No back button, no own nav: HairdresserMainShell owns navigation.
class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'My Applications - Coming Soon',
          style: AppTextStyles.titleMd.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
