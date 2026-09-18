import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/opportunity_summary.dart';
import 'hairdresser_main_shell.dart';

/// Application Sent: a terminal confirmation screen reached after
/// applying for a shift. No back button, no sidebar, no bottom-nav —
/// "View My Applications" is the only way forward.
class ApplicationSentScreen extends StatelessWidget {
  ApplicationSentScreen({super.key, required this.opportunity})
    : applicationRef = 'YNK-APP-${1000 + Random().nextInt(9000)}';

  final OpportunitySummary opportunity;

  /// Generated once per screen instance (the constructor only runs
  /// when this screen is first pushed), so it stays stable for the
  /// life of this confirmation view.
  final String applicationRef;

  static const _bannerImage = 'assets/images/salon_stylist_banner.png';

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  bool _isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = _isTablet(context);
    final bool landscape = _isLandscape(context);
    final bool fixedSizing = tablet || landscape;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: fixedSizing ? 24 : 24.w,
            vertical: fixedSizing ? 20 : 24.h,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tablet ? 640 : 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (tablet) ...[_buildBanner(), const SizedBox(height: 24)],

                  Container(
                    width: fixedSizing ? 88 : 88.r,
                    height: fixedSizing ? 88 : 88.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: fixedSizing ? 56 : 56.sp,
                    ),
                  ),

                  SizedBox(height: fixedSizing ? 20 : 24.h),

                  Text(
                    'Application Sent',
                    style: AppTextStyles.headlineSm,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: fixedSizing ? 8 : 8.h),

                  Text(
                    "We've notified ${opportunity.salonName}. You'll be "
                    'alerted as soon as they respond.',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: fixedSizing ? 24 : 28.h),

                  _buildSummaryCard(fixedSizing: fixedSizing),

                  SizedBox(height: fixedSizing ? 24 : 28.h),

                  SizedBox(
                    width: double.infinity,
                    height: fixedSizing ? 52 : 52.h,
                    child: ElevatedButton(
                      onPressed: () => _viewApplications(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            fixedSizing ? 8 : 8.r,
                          ),
                        ),
                      ),
                      child: Text(
                        'View My Applications',
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
        ),
      ),
    );
  }

  void _viewApplications(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HairdresserMainShell(initialIndex: 2),
      ),
      (route) => false,
    );
  }

  // ============================================================
  // TABLET BANNER
  //
  // A fixed 180-logical-pixel-tall SizedBox — safe inside the
  // SingleChildScrollView above since it's a concrete finite height,
  // not double.infinity/Expanded/stretch.
  // ============================================================

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(_bannerImage, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.textPrimary.withValues(alpha: 0.05),
                    AppColors.textPrimary.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummaryCard({required bool fixedSizing}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(fixedSizing ? 16 : 16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(fixedSizing ? 12 : 12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Expanded (not a bare Text) so a long ref value can
              // never force a RenderFlex overflow — the label
              // ellipsizes instead, consistent with every other detail
              // row on this screen.
              Expanded(
                child: Text(
                  'Application Ref',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelLg,
                ),
              ),
              SizedBox(width: fixedSizing ? 12 : 12.w),
              Text(applicationRef, style: AppTextStyles.titleSm),
            ],
          ),

          SizedBox(height: fixedSizing ? 12 : 12.h),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Status',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelLg,
                ),
              ),
              SizedBox(width: fixedSizing ? 12 : 12.w),
              _buildStatusBadge(),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: fixedSizing ? 12 : 12.h),
            child: Container(height: 1, color: AppColors.border),
          ),

          _buildDetailRow('Salon', opportunity.salonName, fixedSizing),

          SizedBox(height: fixedSizing ? 10 : 10.h),

          _buildDetailRow('Shift Date', opportunity.date, fixedSizing),

          SizedBox(height: fixedSizing ? 10 : 10.h),

          _buildDetailRow('Hours', opportunity.hours, fixedSizing),

          SizedBox(height: fixedSizing ? 10 : 10.h),

          _buildDetailRow(
            'Pay',
            '£${opportunity.payAmount.toStringAsFixed(0)}',
            fixedSizing,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool fixedSizing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        SizedBox(width: fixedSizing ? 12 : 12.w),

        Text(value, textAlign: TextAlign.right, style: AppTextStyles.bodyMd),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Pending Review',
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.background,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
