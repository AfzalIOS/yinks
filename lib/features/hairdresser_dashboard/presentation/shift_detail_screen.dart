import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/opportunity_summary.dart';
import 'application_sent_screen.dart';

/// Shift Detail: an INNER/PUSHED screen (not a root tab) — no sidebar,
/// no drawer, no bottom-nav even on tablet, just a back button. Any
/// header content scrolls with the rest of the page (never sticky).
///
/// Layouts, chosen purely from
/// `MediaQuery.sizeOf(context).shortestSide >= 600` (tablet) crossed
/// with orientation — never a raw `width > 600` check:
/// - Mobile portrait: refined single-column stack, ScreenUtil sizing.
/// - Mobile landscape: same stack, tightened spacing, fixed logical
///   pixels, and a 2-column arrangement for the four detail fields so
///   the card doesn't force excess scrolling in a short viewport.
/// - Tablet (portrait AND landscape): the same split screen — a fixed
///   image + content Row (safe here because it sits directly under
///   SafeArea, never inside a SingleChildScrollView) — landscape uses
///   a wider ~40/60 image/content ratio, portrait a narrower ~35/65
///   ratio to suit the narrower available width.
class ShiftDetailScreen extends StatelessWidget {
  const ShiftDetailScreen({super.key, required this.opportunity});

  final OpportunitySummary opportunity;

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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: tablet
            ? _buildTabletSplitLayout(context, landscape: landscape)
            : _buildStackedLayout(
                context,
                fixedSizing: tablet || landscape,
                mobileLandscape: !tablet && landscape,
                maxWidth: tablet ? 760 : 700,
              ),
      ),
    );
  }

  // ============================================================
  // MOBILE PORTRAIT / MOBILE LANDSCAPE / TABLET PORTRAIT
  //
  // Same single-column stack in all three; only spacing units and the
  // Shift Details card's column count change.
  // ============================================================

  Widget _buildStackedLayout(
    BuildContext context, {
    required bool fixedSizing,
    required bool mobileLandscape,
    required double maxWidth,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: fixedSizing ? 24 : 24.w,
        vertical: fixedSizing ? 16 : 20.h,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),

              SizedBox(height: fixedSizing ? 8 : 12.h),

              Text(
                '${opportunity.salonName} — ${opportunity.role}',
                style: AppTextStyles.headlineSm,
              ),

              SizedBox(height: fixedSizing ? 16 : 20.h),

              _buildSalonRow(fixedSizing: fixedSizing),

              SizedBox(height: fixedSizing ? 20 : 26.h),

              Text('Shift Details', style: AppTextStyles.titleMd),

              SizedBox(height: fixedSizing ? 10 : 12.h),

              _buildDetailsCard(
                fixedSizing: fixedSizing,
                twoColumn: mobileLandscape,
              ),

              SizedBox(height: fixedSizing ? 20 : 26.h),

              _buildRequirementsSection(fixedSizing: fixedSizing),

              SizedBox(height: fixedSizing ? 20 : 26.h),

              _buildAboutSection(fixedSizing: fixedSizing),

              SizedBox(height: fixedSizing ? 22 : 30.h),

              _buildApplyButton(context: context, fixedSizing: fixedSizing),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TABLET (PORTRAIT & LANDSCAPE) — SPLIT SCREEN
  // ============================================================

  Widget _buildTabletSplitLayout(
    BuildContext context, {
    required bool landscape,
  }) {
    // Landscape has more available width to give the image panel
    // before the content column feels cramped; portrait keeps the
    // image narrower so the content side still has room to breathe.
    final int imageFlex = landscape ? 40 : 35;
    final int contentFlex = 100 - imageFlex;

    // Safe to stretch here: this Row sits directly under SafeArea, not
    // inside a SingleChildScrollView, so it always gets a bounded
    // height from the Scaffold — never the unbounded-height crash that
    // CrossAxisAlignment.stretch causes inside a scrollable.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: imageFlex, child: _buildImagePanel(context)),
        Expanded(flex: contentFlex, child: _buildTabletSplitContent(context)),
      ],
    );
  }

  Widget _buildImagePanel(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(_bannerImage, fit: BoxFit.cover),

        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.textPrimary.withValues(alpha: 0.15),
                AppColors.textPrimary.withValues(alpha: 0.78),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBackButton(context, overlay: true),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    opportunity.salonName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineSm.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    opportunity.role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSm.copyWith(
                      color: AppColors.background.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opportunity.salonLocation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.background.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletSplitContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shift Details', style: AppTextStyles.titleMd),

              const SizedBox(height: 10),

              _buildDetailsCard(fixedSizing: true, twoColumn: false),

              const SizedBox(height: 22),

              _buildRequirementsSection(fixedSizing: true),

              const SizedBox(height: 22),

              _buildAboutSection(fixedSizing: true),

              const SizedBox(height: 24),

              _buildApplyButton(context: context, fixedSizing: true),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SHARED PIECES
  // ============================================================

  Widget _buildBackButton(BuildContext context, {bool overlay = false}) {
    if (!overlay) {
      return IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    // Overlaid on the hero image, so it needs its own contrasting
    // background rather than relying on the page background.
    return Material(
      color: AppColors.textPrimary.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.of(context).maybePop(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.arrow_back, color: AppColors.background),
        ),
      ),
    );
  }

  Widget _buildSalonRow({required bool fixedSizing}) {
    final double avatarRadius = fixedSizing ? 28 : 28.r;

    return Row(
      children: [
        _buildAvatar(avatarRadius),

        SizedBox(width: fixedSizing ? 14 : 14.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opportunity.salonName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSm,
              ),

              SizedBox(height: fixedSizing ? 2 : 2.h),

              Text(
                opportunity.salonLocation,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(double radius) {
    if (opportunity.photoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(opportunity.photoUrl!),
      );
    }

    final initials = opportunity.salonName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        initials,
        style: AppTextStyles.titleSm.copyWith(color: AppColors.background),
      ),
    );
  }

  Widget _buildDetailsCard({
    required bool fixedSizing,
    required bool twoColumn,
  }) {
    final double padding = fixedSizing ? 18 : 18.w;
    final double radius = fixedSizing ? 14 : 14.r;

    final rows = [
      _buildDetailRow(
        icon: Icons.calendar_today_outlined,
        label: 'Date',
        value: opportunity.date,
        fixedSizing: fixedSizing,
      ),
      _buildDetailRow(
        icon: Icons.schedule_outlined,
        label: 'Hours',
        value: opportunity.hours,
        fixedSizing: fixedSizing,
      ),
      _buildDetailRow(
        icon: Icons.payments_outlined,
        label: 'Pay',
        value: '£${opportunity.payAmount.toStringAsFixed(0)}',
        valueStyle: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
        fixedSizing: fixedSizing,
      ),
      _buildDetailRow(
        icon: Icons.location_on_outlined,
        label: 'Distance',
        value: '${opportunity.distanceMiles} mi away',
        fixedSizing: fixedSizing,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border),
      ),
      child: twoColumn
          ? Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: rows[0]),
                    const SizedBox(width: 16),
                    Expanded(child: rows[1]),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: rows[2]),
                    const SizedBox(width: 16),
                    Expanded(child: rows[3]),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                for (int i = 0; i < rows.length; i++) ...[
                  rows[i],
                  if (i != rows.length - 1) ...[
                    SizedBox(height: fixedSizing ? 12 : 12.h),
                    Container(height: 1, color: AppColors.border),
                    SizedBox(height: fixedSizing ? 12 : 12.h),
                  ],
                ],
              ],
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool fixedSizing,
    TextStyle? valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: fixedSizing ? 18 : 18.sp, color: AppColors.primary),

        SizedBox(width: fixedSizing ? 10 : 10.w),

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

        Text(
          value,
          textAlign: TextAlign.right,
          style: valueStyle ?? AppTextStyles.bodyMd,
        ),
      ],
    );
  }

  Widget _buildRequirementsSection({required bool fixedSizing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Requirements', style: AppTextStyles.titleMd),

        SizedBox(height: fixedSizing ? 8 : 8.h),

        Text(
          'Looking for an experienced '
          '${opportunity.role.replaceAll('Needed', '').trim().toLowerCase()} '
          'comfortable working independently in a fast-paced salon '
          'environment. Own kit preferred. Punctuality and a '
          'professional, client-first attitude are essential.',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAboutSection({required bool fixedSizing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About This Salon', style: AppTextStyles.titleMd),

        SizedBox(height: fixedSizing ? 8 : 8.h),

        Text(
          '${opportunity.salonName} is a well-established salon in '
          '${opportunity.salonLocation} known for its welcoming atelier '
          'atmosphere and loyal clientele. The team values reliable, '
          'skilled freelancers who take pride in their craft.',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildApplyButton({
    required BuildContext context,
    required bool fixedSizing,
  }) {
    return SizedBox(
      width: double.infinity,
      height: fixedSizing ? 52 : 52.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ApplicationSentScreen(opportunity: opportunity),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(fixedSizing ? 8 : 8.r),
          ),
        ),
        child: Text(
          'Apply for This Shift',
          style: AppTextStyles.titleMd.copyWith(color: AppColors.background),
        ),
      ),
    );
  }
}
