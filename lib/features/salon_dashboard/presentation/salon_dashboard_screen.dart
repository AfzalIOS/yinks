import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_salon_repository.dart';
import '../domain/hairdresser_summary.dart';
import '../domain/salon_repository.dart';
import 'salon_profile_screen.dart';

class _DashboardData {
  const _DashboardData({
    required this.hairdressers,
    required this.activeInvites,
    required this.upcomingShifts,
  });

  final List<HairdresserSummary> hairdressers;
  final int activeInvites;
  final int upcomingShifts;
}

class SalonDashboardScreen extends StatefulWidget {
  const SalonDashboardScreen({super.key, required this.onNavigateToTab});

  final ValueChanged<int> onNavigateToTab;

  @override
  State<SalonDashboardScreen> createState() => _SalonDashboardScreenState();
}

class _SalonDashboardScreenState extends State<SalonDashboardScreen> {
  final SalonRepository _repository = MockSalonRepository();

  late final Future<_DashboardData> _future = _loadDashboard();

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  bool _isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  Future<_DashboardData> _loadDashboard() async {
    final results = await Future.wait([
      _repository.getRecommendedHairdressers(),
      _repository.getActiveInvitesCount(),
      _repository.getUpcomingShiftsCount(),
    ]);

    return _DashboardData(
      hairdressers: results[0] as List<HairdresserSummary>,
      activeInvites: results[1] as int,
      upcomingShifts: results[2] as int,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = _isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<_DashboardData>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final data = snapshot.data!;

            if (isTablet) {
              return _buildTabletDashboard(context, data);
            }

            return _buildMobileDashboard(context, data);
          },
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileDashboard(BuildContext context, _DashboardData data) {
    final bool landscape = _isLandscape(context);

    final double horizontalPadding = landscape ? 24 : 24.w;

    final double verticalPadding = landscape ? 16 : 24.h;

    final double sectionSpacing = landscape ? 18 : 24.h;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileHeader(context, landscape),

          SizedBox(height: sectionSpacing),

          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  label: 'Active Invites',
                  count: data.activeInvites,
                  icon: Icons.person_add_alt_1_outlined,
                  onTap: () => widget.onNavigateToTab(2),
                  mobileLandscape: landscape,
                ),
              ),

              SizedBox(width: landscape ? 14 : 16.w),

              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  label: 'Upcoming Shifts',
                  count: data.upcomingShifts,
                  icon: Icons.calendar_month_outlined,
                  onTap: () => widget.onNavigateToTab(3),
                  mobileLandscape: landscape,
                ),
              ),
            ],
          ),

          SizedBox(height: landscape ? 16 : 18.h),

          SizedBox(
            width: double.infinity,
            child: _buildFeaturedCard(context, mobileLandscape: landscape),
          ),

          SizedBox(height: sectionSpacing),

          _buildRecommendedHeader(),

          SizedBox(height: landscape ? 12 : 12.h),

          for (int index = 0; index < data.hairdressers.length; index++) ...[
            _buildHairdresserCard(
              context,
              data.hairdressers[index],
              mobileLandscape: landscape,
            ),

            if (index != data.hairdressers.length - 1)
              SizedBox(height: landscape ? 12 : 12.h),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context, bool landscape) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Maison Mayfair', style: AppTextStyles.headlineSm),
              SizedBox(height: landscape ? 4 : 4.h),
              Text(
                'Mayfair Atelier',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: _openProfile,
          icon: Icon(Icons.person_outline, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  // ============================================================
  // TABLET DASHBOARD
  // ============================================================

  Widget _buildTabletDashboard(BuildContext context, _DashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabletHeader(),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      context: context,
                      label: 'Active Invites',
                      count: data.activeInvites,
                      icon: Icons.person_add_alt_1_outlined,
                      onTap: () => widget.onNavigateToTab(2),
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: _buildSummaryCard(
                      context: context,
                      label: 'Upcoming Shifts',
                      count: data.upcomingShifts,
                      icon: Icons.calendar_month_outlined,
                      onTap: () => widget.onNavigateToTab(3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: _buildFeaturedCard(context),
              ),

              const SizedBox(height: 22),

              _buildRecommendedHeader(),

              const SizedBox(height: 12),

              _buildTabletHairdresserGrid(context, data.hairdressers),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back,',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 2),

              Text('Maison Mayfair', style: AppTextStyles.headlineMd),

              const SizedBox(height: 4),

              Text(
                "Here's what's happening today.",
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: _openProfile,
          icon: Icon(
            Icons.person_outline,
            size: 25,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  void _openProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SalonProfileScreen()));
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummaryCard({
    required BuildContext context,
    required String label,
    required int count,
    required IconData icon,
    required VoidCallback onTap,
    bool mobileLandscape = false,
  }) {
    final bool tablet = _isTablet(context);

    if (tablet) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 29, color: AppColors.primary),

              const SizedBox(width: 18),

              Text('$count', style: AppTextStyles.headlineSm),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (mobileLandscape) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 92,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: AppColors.primary),

              const SizedBox(width: 12),

              Text('$count', style: AppTextStyles.headlineSm),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('$count', style: AppTextStyles.headlineSm),
                ),
                Icon(icon, size: 22.sp, color: AppColors.primary),
              ],
            ),

            SizedBox(height: 4.h),

            Text(
              label,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BANNER
  // ============================================================

  Widget _buildFeaturedCard(
    BuildContext context, {
    bool mobileLandscape = false,
  }) {
    final bool tablet = _isTablet(context);

    final double radius = tablet || mobileLandscape ? 16 : 16.r;

    // No fixed height here on purpose: a SizedBox(height: ...) +
    // Stack(fit: StackFit.expand) forces the content Column into that
    // exact box, and it was overflowing by a few pixels on both mobile
    // orientations once the label/heading/subtitle/button didn't quite
    // fit the hand-picked 175/185.h guess. Instead, the image and
    // gradient are Positioned.fill layers behind a normally-sized
    // (mainAxisSize.min) content Column, so the card's height is
    // always exactly "however tall the content plus padding is" — it
    // can never overflow itself, on any screen size or orientation.
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/salon_stylist_banner.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.textPrimary.withValues(alpha: 0.82),
                    AppColors.textPrimary.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tablet || mobileLandscape ? 26 : 18.w,
              vertical: tablet || mobileLandscape ? 22 : 18.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FIND THE RIGHT TALENT',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.background,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Need a Stylist Today?',
                  style: AppTextStyles.headlineSm.copyWith(
                    color: AppColors.background,
                  ),
                ),

                const SizedBox(height: 6),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Text(
                    'Browse available hairdressers ready to work on short notice.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.background.withValues(alpha: 0.90),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: () => widget.onNavigateToTab(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search,
                          size: 18,
                          color: AppColors.background,
                        ),

                        const SizedBox(width: 8),

                        // Flexible (not a bare Text) so this pill can
                        // never force a RenderFlex overflow on a
                        // narrow card — it ellipsizes instead if the
                        // available width is ever too tight for the
                        // full label.
                        Flexible(
                          child: Text(
                            'Find Available Stylists',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelLg.copyWith(
                              color: AppColors.background,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: AppColors.background,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECOMMENDED HEADER
  // ============================================================

  Widget _buildRecommendedHeader() {
    return Row(
      children: [
        Expanded(
          child: Text('Recommended Near You', style: AppTextStyles.titleMd),
        ),

        GestureDetector(
          onTap: () => widget.onNavigateToTab(1),
          child: Text(
            'See All',
            style: AppTextStyles.labelLg.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TABLET GRID
  // ============================================================

  Widget _buildTabletHairdresserGrid(
    BuildContext context,
    List<HairdresserSummary> hairdressers,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 14;

        final double cardWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final hairdresser in hairdressers)
              SizedBox(
                width: cardWidth,
                child: _buildHairdresserCard(context, hairdresser),
              ),
          ],
        );
      },
    );
  }

  // ============================================================
  // HAIRDRESSER CARD
  // ============================================================

  Widget _buildHairdresserCard(
    BuildContext context,
    HairdresserSummary hairdresser, {
    bool mobileLandscape = false,
  }) {
    final bool fixedSizing = _isTablet(context) || mobileLandscape;

    final double padding = fixedSizing ? 12 : 12.w;

    final double radius = fixedSizing ? 12 : 12.r;

    final double avatarRadius = fixedSizing ? 28 : 28.r;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildAvatar(hairdresser, avatarRadius),

          SizedBox(width: fixedSizing ? 12 : 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hairdresser.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSm,
                ),

                const SizedBox(height: 2),

                Text(
                  hairdresser.specialty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: AppColors.primary),

                    const SizedBox(width: 4),

                    Text(
                      '${hairdresser.rating} (${hairdresser.reviewCount})',
                      style: AppTextStyles.labelMd,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        hairdresser.availabilityLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '£${hairdresser.ratePerDay.toStringAsFixed(0)}/day',
                style: AppTextStyles.titleSm,
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 34,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Profile',
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar(HairdresserSummary hairdresser, double radius) {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: radius,
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
      radius: radius,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        initials,
        style: AppTextStyles.titleSm.copyWith(color: AppColors.background),
      ),
    );
  }
}
