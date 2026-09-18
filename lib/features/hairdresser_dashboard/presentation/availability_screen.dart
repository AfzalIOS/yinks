import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Availability root tab. Placeholder — built out in a later task.
/// No back button, no own nav: HairdresserMainShell owns navigation.
class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Availability - Coming Soon',
          style: AppTextStyles.titleMd.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
