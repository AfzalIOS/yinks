import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_salon_repository.dart';
import '../domain/hairdresser_summary.dart';
import '../domain/salon_repository.dart';
import 'hairdresser_profile_screen.dart';

const List<String> _filters = [
  'All Specialties',
  'Balayage',
  'Colorists',
  'Precision Cuts',
];

class FindHairdressersScreen extends StatefulWidget {
  const FindHairdressersScreen({
    super.key,
    this.showBackButton = true,
    this.onHairdresserSelected,
  });

  final bool showBackButton;

  /// Tablet shell ke liye.
  /// Agar callback available hai to profile Navigator.push()
  /// ke bajaye shell ke content area mein open hoga.
  final ValueChanged<HairdresserSummary>? onHairdresserSelected;

  @override
  State<FindHairdressersScreen> createState() => _FindHairdressersScreenState();
}

class _FindHairdressersScreenState extends State<FindHairdressersScreen> {
  final SalonRepository _repository = MockSalonRepository();

  late final Future<List<HairdresserSummary>> _future = _repository
      .getAllHairdressers();

  String _selectedFilter = _filters.first;

  // ============================================================
  // DEVICE CHECKS
  // ============================================================

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  bool _isPhoneLandscape(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return mediaQuery.size.shortestSide < 600 &&
        mediaQuery.orientation == Orientation.landscape;
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<HairdresserSummary> _applyFilter(List<HairdresserSummary> all) {
    if (_selectedFilter == _filters.first) {
      return all;
    }

    final query = _selectedFilter.toLowerCase();

    return all.where((hairdresser) {
      return hairdresser.specialty.toLowerCase().contains(query);
    }).toList();
  }

  // ============================================================
  // PROFILE NAVIGATION
  // ============================================================

  void _openProfile(HairdresserSummary hairdresser) {
    // Tablet shell callback available ho to shell profile open karega.
    if (widget.onHairdresserSelected != null) {
      widget.onHairdresserSelected!(hairdresser);
      return;
    }

    // Mobile portrait + landscape:
    // normal full-screen profile.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HairdresserProfileScreen(hairdresser: hairdresser),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isTablet = _isTablet(context);
    final bool isPhoneLandscape = _isPhoneLandscape(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HEADER
            // ==================================================
            Padding(
              padding: isTablet || isPhoneLandscape
                  ? const EdgeInsets.fromLTRB(24, 20, 24, 0)
                  : EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
              child: Row(
                children: [
                  if (widget.showBackButton) ...[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: isTablet || isPhoneLandscape ? 8 : 8.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Hairdressers',
                          style: AppTextStyles.headlineSm,
                        ),
                        SizedBox(
                          height: isTablet || isPhoneLandscape ? 4 : 4.h,
                        ),
                        Text(
                          'Freelance artists available in '
                          'Mayfair, Chelsea & Soho',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isTablet || isPhoneLandscape ? 16 : 20.h),

            // ==================================================
            // FILTERS
            // ==================================================
            SizedBox(
              height: isTablet || isPhoneLandscape ? 40 : 40.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: isTablet || isPhoneLandscape
                    ? const EdgeInsets.symmetric(horizontal: 24)
                    : EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: _filters.length,
                separatorBuilder: (_, _) =>
                    SizedBox(width: isTablet || isPhoneLandscape ? 8 : 8.w),
                itemBuilder: (context, index) {
                  return _buildFilterChip(
                    _filters[index],
                    useLogicalPixels: isTablet || isPhoneLandscape,
                  );
                },
              ),
            ),

            SizedBox(height: isTablet || isPhoneLandscape ? 16 : 16.h),

            // ==================================================
            // CONTENT
            // ==================================================
            Expanded(
              child: FutureBuilder<List<HairdresserSummary>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Unable to load hairdressers.',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final allHairdressers =
                      snapshot.data ?? <HairdresserSummary>[];

                  final results = _applyFilter(allHairdressers);

                  if (results.isEmpty) {
                    return Center(
                      child: Text(
                        'No hairdressers match this filter.',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  // TABLET
                  // 2 columns + drawer shell ke through.
                  if (isTablet) {
                    return _buildTabletGrid(results);
                  }

                  // MOBILE LANDSCAPE
                  // 2 columns, NO drawer.
                  if (isPhoneLandscape) {
                    return _buildPhoneLandscapeGrid(results);
                  }

                  // MOBILE PORTRAIT
                  // 1 column.
                  return _buildMobilePortraitList(results);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE PORTRAIT
  // 1 COLUMN
  // ============================================================

  Widget _buildMobilePortraitList(List<HairdresserSummary> results) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      itemCount: results.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _buildHairdresserCard(
          results[index],
          layout: _CardLayout.mobilePortrait,
        );
      },
    );
  }

  // ============================================================
  // MOBILE LANDSCAPE
  // 2 COLUMNS
  // ============================================================

  Widget _buildPhoneLandscapeGrid(List<HairdresserSummary> results) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double horizontalPadding = 24;
        const double gap = 12;

        final double availableWidth =
            constraints.maxWidth - (horizontalPadding * 2);

        final double cardWidth = (availableWidth - gap) / 2;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            24,
          ),
          child: Wrap(
            spacing: gap,
            runSpacing: 12,
            children: [
              for (final hairdresser in results)
                SizedBox(
                  width: cardWidth,
                  child: _buildHairdresserCard(
                    hairdresser,
                    layout: _CardLayout.mobileLandscape,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // TABLET
  // 2 COLUMNS
  //
  // NOTE:
  // Drawer width yahan subtract NAHI karni.
  // SalonMainShell already drawer ke baad available width deta hai.
  // ============================================================

  Widget _buildTabletGrid(List<HairdresserSummary> results) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double horizontalPadding = 32;
        const double gap = 16;
        const double maxContentWidth = 1200;

        final double usableWidth = constraints.maxWidth > maxContentWidth
            ? maxContentWidth
            : constraints.maxWidth;

        final double cardsAreaWidth = usableWidth - (horizontalPadding * 2);

        final double cardWidth = (cardsAreaWidth - gap) / 2;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Center(
            child: SizedBox(
              width: usableWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final hairdresser in results)
                      SizedBox(
                        width: cardWidth,
                        child: _buildHairdresserCard(
                          hairdresser,
                          layout: _CardLayout.tablet,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // FILTER CHIP
  // ============================================================

  Widget _buildFilterChip(String label, {required bool useLogicalPixels}) {
    final bool isSelected = label == _selectedFilter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: useLogicalPixels ? 16 : 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(useLogicalPixels ? 20 : 20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLg.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HAIRDRESSER CARD
  // ============================================================

  Widget _buildHairdresserCard(
    HairdresserSummary hairdresser, {
    required _CardLayout layout,
  }) {
    final bool isMobilePortrait = layout == _CardLayout.mobilePortrait;

    final bool isMobileLandscape = layout == _CardLayout.mobileLandscape;

    final double padding = isMobilePortrait ? 14.w : 14;

    final double radius = isMobilePortrait ? 12.r : 12;

    final double avatarRadius = isMobilePortrait
        ? 26.r
        : isMobileLandscape
        ? 23
        : 27;

    final double horizontalGap = isMobilePortrait ? 12.w : 12;

    final double topBottomGap = isMobilePortrait ? 10.h : 10;

    final double buttonHeight = isMobilePortrait ? 40.h : 40;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // TOP
          // ====================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(
                hairdresser,
                radius: avatarRadius,
                useLogicalPixels: !isMobilePortrait,
              ),

              SizedBox(width: horizontalGap),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hairdresser.name,
                      style: AppTextStyles.titleSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isMobilePortrait ? 2.h : 2),
                    Text(
                      hairdresser.specialty,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Text(
                '£${hairdresser.ratePerDay.toStringAsFixed(0)}/day',
                style: AppTextStyles.titleSm,
              ),
            ],
          ),

          SizedBox(height: topBottomGap),

          // ====================================================
          // RATING + LOCATION
          // ====================================================
          Row(
            children: [
              Icon(
                Icons.star,
                size: isMobilePortrait ? 14.sp : 14,
                color: AppColors.primary,
              ),

              SizedBox(width: isMobilePortrait ? 4.w : 4),

              Text(
                '${hairdresser.rating} '
                '(${hairdresser.reviewCount})',
                style: AppTextStyles.labelMd,
              ),

              SizedBox(width: isMobilePortrait ? 12.w : 10),

              Icon(
                Icons.location_on_outlined,
                size: isMobilePortrait ? 14.sp : 14,
                color: AppColors.textSecondary,
              ),

              SizedBox(width: isMobilePortrait ? 2.w : 2),

              Expanded(
                child: Text(
                  '${hairdresser.locationArea} · '
                  '${hairdresser.yearsExperience} yrs exp',
                  style: AppTextStyles.labelMd,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: isMobilePortrait ? 6.h : 6),

          // ====================================================
          // AVAILABILITY
          // ====================================================
          Text(
            hairdresser.availabilityLabel,
            style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: isMobilePortrait ? 12.h : 12),

          // ====================================================
          // VIEW PROFILE
          // ====================================================
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: OutlinedButton(
              onPressed: () => _openProfile(hairdresser),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    isMobilePortrait ? 8.r : 8,
                  ),
                ),
              ),
              child: Text(
                'View Profile',
                style: AppTextStyles.labelLg.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar(
    HairdresserSummary hairdresser, {
    required double radius,
    required bool useLogicalPixels,
  }) {
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

// ============================================================
// CARD LAYOUT TYPE
// ============================================================

enum _CardLayout { mobilePortrait, mobileLandscape, tablet }
