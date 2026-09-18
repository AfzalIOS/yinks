import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_hairdresser_repository.dart';
import '../domain/hairdresser_repository.dart';
import '../domain/opportunity_summary.dart';
import 'opportunity_card.dart';
import 'shift_detail_screen.dart';

enum _OpportunityFilter { all, thisWeek, nearby, highestPay }

extension on _OpportunityFilter {
  String get label => switch (this) {
    _OpportunityFilter.all => 'All',
    _OpportunityFilter.thisWeek => 'This Week',
    _OpportunityFilter.nearby => 'Nearby',
    _OpportunityFilter.highestPay => 'Highest Pay',
  };
}

/// Opportunities root tab (index 1 in HairdresserMainShell). No back
/// button, no own sidebar/bottom-nav: the shell owns navigation.
/// Backed by [HairdresserRepository] so a real (Firebase)
/// implementation can replace [MockHairdresserRepository] later
/// without any UI changes.
class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  final HairdresserRepository _repository = MockHairdresserRepository();

  late final Future<List<OpportunitySummary>> _future = _repository
      .getAllOpportunities();

  _OpportunityFilter _selectedFilter = _OpportunityFilter.all;

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  bool _isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  void _openShiftDetail(BuildContext context, OpportunitySummary opportunity) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShiftDetailScreen(opportunity: opportunity),
      ),
    );
  }

  List<OpportunitySummary> _applyFilter(List<OpportunitySummary> all) {
    final results = List<OpportunitySummary>.of(all);

    switch (_selectedFilter) {
      case _OpportunityFilter.all:
      case _OpportunityFilter.thisWeek:
        // The mock data only has weekday names, not real calendar
        // dates, so there's nothing to genuinely filter "this week"
        // against yet — it shows the same set as "All" until a real
        // date field is added to OpportunitySummary.
        break;
      case _OpportunityFilter.nearby:
        results.sort((a, b) => a.distanceMiles.compareTo(b.distanceMiles));
        break;
      case _OpportunityFilter.highestPay:
        results.sort((a, b) => b.payAmount.compareTo(a.payAmount));
        break;
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = _isTablet(context);
    final bool mobileLandscape = !tablet && _isLandscape(context);
    final bool fixedSizing = tablet || mobileLandscape;
    final bool twoColumn = tablet || mobileLandscape;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                fixedSizing ? 24 : 24.w,
                fixedSizing ? 20 : 24.h,
                fixedSizing ? 24 : 24.w,
                0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Opportunities', style: AppTextStyles.headlineSm),

                      SizedBox(height: fixedSizing ? 4 : 4.h),

                      Text(
                        'Shifts matching your skills, updated daily',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: fixedSizing ? 16 : 16.h),

            SizedBox(
              height: fixedSizing ? 38 : 38.h,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: fixedSizing ? 24 : 24.w,
                      ),
                      itemCount: _OpportunityFilter.values.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(width: fixedSizing ? 8 : 8.w),
                      itemBuilder: (context, index) => _buildFilterChip(
                        _OpportunityFilter.values[index],
                        fixedSizing: fixedSizing,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: fixedSizing ? 16 : 16.h),

            Expanded(
              child: FutureBuilder<List<OpportunitySummary>>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  final results = _applyFilter(snapshot.data!);

                  if (results.isEmpty) {
                    return Center(
                      child: Text(
                        'No opportunities match this filter.',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  // Align(topCenter), not Center: this only needs to
                  // horizontally center the max-width-1200 content.
                  // Center also centers VERTICALLY, and — unlike
                  // ListView, which always fills the available
                  // Expanded height — _buildGrid's SingleChildScrollView
                  // shrink-wraps to its actual (often short, e.g. on
                  // tablet's 2-column grid) content height under
                  // Center's loose constraints. Center then centered
                  // that short content within the leftover space,
                  // pushing it down by as much as 150px in testing.
                  // topCenter keeps the horizontal centering without
                  // that vertical side effect, for both the list and
                  // grid paths.
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: twoColumn
                          ? _buildGrid(results, fixedSizing: fixedSizing)
                          : _buildList(results, fixedSizing: fixedSizing),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    _OpportunityFilter filter, {
    required bool fixedSizing,
  }) {
    final bool isSelected = filter == _selectedFilter;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: fixedSizing ? 16 : 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(fixedSizing ? 20 : 20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          filter.label,
          style: AppTextStyles.labelLg.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE PORTRAIT — 1 COLUMN
  // ============================================================

  Widget _buildList(
    List<OpportunitySummary> opportunities, {
    required bool fixedSizing,
  }) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        fixedSizing ? 24 : 24.w,
        0,
        fixedSizing ? 24 : 24.w,
        fixedSizing ? 24 : 24.h,
      ),
      itemCount: opportunities.length,
      separatorBuilder: (_, _) => SizedBox(height: fixedSizing ? 12 : 12.h),
      itemBuilder: (context, index) => OpportunityCard(
        opportunity: opportunities[index],
        fixedSizing: fixedSizing,
        onViewDetails: () => _openShiftDetail(context, opportunities[index]),
      ),
    );
  }

  // ============================================================
  // MOBILE LANDSCAPE / TABLET — 2 COLUMNS
  // ============================================================

  Widget _buildGrid(
    List<OpportunitySummary> opportunities, {
    required bool fixedSizing,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        fixedSizing ? 24 : 24.w,
        0,
        fixedSizing ? 24 : 24.w,
        fixedSizing ? 24 : 24.h,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 14;

          final double cardWidth = (constraints.maxWidth - spacing) / 2;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final opportunity in opportunities)
                SizedBox(
                  width: cardWidth,
                  child: OpportunityCard(
                    opportunity: opportunity,
                    fixedSizing: true,
                    onViewDetails: () => _openShiftDetail(context, opportunity),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
