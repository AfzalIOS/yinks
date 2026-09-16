import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/hairdresser_summary.dart';
import 'book_shift_screen.dart';

/// Extended profile view for a single [HairdresserSummary], reached
/// from the Find Hairdressers list.
class HairdresserProfileScreen extends StatelessWidget {
  const HairdresserProfileScreen({super.key, required this.hairdresser});

  final HairdresserSummary hairdresser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        'Vetted Freelancer',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildAvatar(),
                    SizedBox(height: 16.h),
                    Text(
                      hairdresser.name,
                      style: AppTextStyles.headlineSm,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      hairdresser.specialty,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (hairdresser.trainingInfo != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        '${hairdresser.trainingInfo} • '
                        '${hairdresser.locationArea}',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatChip(
                      label: 'Rate/Day',
                      value: '£${hairdresser.ratePerDay.toStringAsFixed(0)}',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatChip(
                      label: 'Rating',
                      value: '★ ${hairdresser.rating} '
                          '(${hairdresser.reviewCount})',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatChip(
                      label: 'Show-up',
                      value: '${hairdresser.showUpPercentage ?? 100}%',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              Text('Experience', style: AppTextStyles.titleMd),
              SizedBox(height: 8.h),
              Text(
                hairdresser.bio ??
                    '${hairdresser.name} has ${hairdresser.yearsExperience} '
                        'years of experience in ${hairdresser.specialty}, '
                        'with a strong track record of reliable, '
                        'high-quality work for salons across London.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 28.h),
              Text('Specialties', style: AppTextStyles.titleMd),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  for (final tag
                      in hairdresser.specialtyTags ?? [hairdresser.specialty])
                    _buildSpecialtyTag(tag),
                ],
              ),
              SizedBox(height: 28.h),
              Text('Recent Work', style: AppTextStyles.titleMd),
              SizedBox(height: 12.h),
              Row(
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    if (i != 0) SizedBox(width: 12.w),
                    Expanded(child: _buildWorkPlaceholder()),
                  ],
                ],
              ),
              SizedBox(height: 28.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_available_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Ready for Cover: '
                        '${hairdresser.readyDate ?? hairdresser.availabilityLabel}',
                        style: AppTextStyles.bodyMd,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            BookShiftScreen(hairdresser: hairdresser),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Send Booking Request',
                    style: AppTextStyles.titleMd.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({required String label, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleSm,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelLg.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildWorkPlaceholder() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          Icons.image_outlined,
          color: AppColors.textSecondary,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: 56.r,
        backgroundImage: NetworkImage(hairdresser.photoUrl!),
      );
    }

    final initials = hairdresser.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: 56.r,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        initials,
        style: AppTextStyles.headlineSm.copyWith(color: AppColors.background),
      ),
    );
  }
}
