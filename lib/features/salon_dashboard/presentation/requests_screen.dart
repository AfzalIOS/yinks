import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_salon_repository.dart';
import '../domain/salon_repository.dart';
import '../domain/shift_request.dart';

enum _RequestFilter { all, pending, accepted, declined }

extension on _RequestFilter {
  String get label => switch (this) {
    _RequestFilter.all => 'All',
    _RequestFilter.pending => 'Pending',
    _RequestFilter.accepted => 'Accepted',
    _RequestFilter.declined => 'Declined',
  };

  ShiftRequestStatus? get status => switch (this) {
    _RequestFilter.all => null,
    _RequestFilter.pending => ShiftRequestStatus.pending,
    _RequestFilter.accepted => ShiftRequestStatus.accepted,
    _RequestFilter.declined => ShiftRequestStatus.declined,
  };
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final SalonRepository _repository = MockSalonRepository();

  late final Future<List<ShiftRequest>> _future = _repository.getMyRequests();

  _RequestFilter _selectedFilter = _RequestFilter.all;

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

  List<ShiftRequest> _applyFilter(List<ShiftRequest> all) {
    final status = _selectedFilter.status;

    if (status == null) {
      return all;
    }

    return all.where((request) {
      return request.status == status;
    }).toList();
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
        child: FutureBuilder<List<ShiftRequest>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Unable to load requests.',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final allRequests = snapshot.data ?? <ShiftRequest>[];

            final results = _applyFilter(allRequests);

            if (isTablet) {
              return _buildTabletLayout(
                results,
                isLandscape:
                    MediaQuery.orientationOf(context) == Orientation.landscape,
              );
            }

            if (isPhoneLandscape) {
              return _buildPhoneLandscapeLayout(results);
            }

            return _buildMobilePortraitLayout(results);
          },
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE PORTRAIT
  // 1 COLUMN
  // Header + filters + cards all scroll
  // ============================================================

  Widget _buildMobilePortraitLayout(List<ShiftRequest> results) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
      children: [
        _buildMobileHeader(),

        SizedBox(height: 16.h),

        _buildMobileFilters(),

        SizedBox(height: 16.h),

        if (results.isEmpty)
          _buildMobileEmptyState()
        else
          ...List.generate(
            results.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == results.length - 1 ? 0 : 12.h,
              ),
              child: _buildRequestCard(
                results[index],
                layout: _RequestCardLayout.mobilePortrait,
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // MOBILE LANDSCAPE
  // 2 COLUMNS
  // Bottom nav remains from SalonMainShell
  // NO drawer
  // ============================================================

  Widget _buildPhoneLandscapeLayout(List<ShiftRequest> results) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double horizontalPadding = 24;
        const double verticalPadding = 18;
        const double gap = 12;

        final double availableWidth =
            constraints.maxWidth - (horizontalPadding * 2);

        final double cardWidth = (availableWidth - gap) / 2;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogicalHeader(),

              const SizedBox(height: 12),

              _buildLogicalFilters(),

              const SizedBox(height: 14),

              if (results.isEmpty)
                _buildLogicalEmptyState()
              else
                Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final request in results)
                      SizedBox(
                        width: cardWidth,
                        child: _buildRequestCard(
                          request,
                          layout: _RequestCardLayout.mobileLandscape,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // TABLET
  //
  // Drawer is NOT created here.
  // SalonMainShell owns the tablet drawer/sidebar.
  //
  // Portrait  = 1 column
  // Landscape = 2 columns
  // ============================================================

  Widget _buildTabletLayout(
    List<ShiftRequest> results, {
    required bool isLandscape,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double horizontalPadding = 32;
        const double verticalPadding = 28;
        const double gap = 16;
        const double maxContentWidth = 1200;

        final double contentWidth = constraints.maxWidth > maxContentWidth
            ? maxContentWidth
            : constraints.maxWidth;

        final double cardsAreaWidth = contentWidth - (horizontalPadding * 2);

        final double cardWidth = isLandscape
            ? (cardsAreaWidth - gap) / 2
            : cardsAreaWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: verticalPadding, bottom: 32),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogicalHeader(),

                    const SizedBox(height: 18),

                    _buildLogicalFilters(),

                    const SizedBox(height: 20),

                    if (results.isEmpty)
                      _buildLogicalEmptyState()
                    else
                      Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          for (final request in results)
                            SizedBox(
                              width: cardWidth,
                              child: _buildRequestCard(
                                request,
                                layout: isLandscape
                                    ? _RequestCardLayout.tabletLandscape
                                    : _RequestCardLayout.tabletPortrait,
                              ),
                            ),
                        ],
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
  // MOBILE HEADER
  // ============================================================

  Widget _buildMobileHeader() {
    return Row(
      children: [
        if (widget.showBackButton) ...[
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: 8.w),
        ],
        Text('Requests', style: AppTextStyles.headlineSm),
      ],
    );
  }

  // ============================================================
  // TABLET / LANDSCAPE HEADER
  // ============================================================

  Widget _buildLogicalHeader() {
    return Row(
      children: [
        if (widget.showBackButton) ...[
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          const SizedBox(width: 8),
        ],
        Text('Requests', style: AppTextStyles.headlineSm),
      ],
    );
  }

  // ============================================================
  // MOBILE FILTERS
  // ============================================================

  Widget _buildMobileFilters() {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _RequestFilter.values.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          return _buildFilterTab(
            _RequestFilter.values[index],
            useLogicalPixels: false,
          );
        },
      ),
    );
  }

  // ============================================================
  // TABLET / MOBILE LANDSCAPE FILTERS
  // ============================================================

  Widget _buildLogicalFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (
            int index = 0;
            index < _RequestFilter.values.length;
            index++
          ) ...[
            if (index > 0) const SizedBox(width: 10),
            _buildFilterTab(
              _RequestFilter.values[index],
              useLogicalPixels: true,
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // FILTER TAB
  // ============================================================

  Widget _buildFilterTab(
    _RequestFilter filter, {
    required bool useLogicalPixels,
  }) {
    final bool isSelected = filter == _selectedFilter;

    final double horizontalPadding = useLogicalPixels ? 22 : 16.w;

    final double radius = useLogicalPixels ? 22 : 20.r;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        height: useLogicalPixels ? 42 : 40.h,
        constraints: BoxConstraints(minWidth: useLogicalPixels ? 110 : 0),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(radius),
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
  // REQUEST CARD
  // ============================================================

  Widget _buildRequestCard(
    ShiftRequest request, {
    required _RequestCardLayout layout,
  }) {
    final bool isMobilePortrait = layout == _RequestCardLayout.mobilePortrait;

    final bool isMobileLandscape = layout == _RequestCardLayout.mobileLandscape;

    final bool isTabletPortrait = layout == _RequestCardLayout.tabletPortrait;

    final double padding = isMobilePortrait ? 14.w : 18;

    final double radius = isMobilePortrait ? 12.r : 14;

    final double avatarRadius = isMobilePortrait
        ? 20.r
        : isMobileLandscape
        ? 21
        : isTabletPortrait
        ? 25
        : 23;

    final double avatarGap = isMobilePortrait ? 12.w : 14;

    final double headerBottomGap = isMobilePortrait ? 12.h : 16;

    final double detailGap = isMobilePortrait ? 8.h : 10;

    return Container(
      width: double.infinity,
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
          // NAME / AVATAR / STATUS
          // ====================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(
                request,
                radius: avatarRadius,
                useLogicalPixels: !isMobilePortrait,
              ),

              SizedBox(width: avatarGap),

              Expanded(
                child: Text(
                  request.hairdresserName,
                  style: AppTextStyles.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(width: isMobilePortrait ? 8.w : 12),

              _buildStatusBadge(
                request.status,
                useLogicalPixels: !isMobilePortrait,
              ),
            ],
          ),

          SizedBox(height: headerBottomGap),

          // ====================================================
          // DETAILS
          // ====================================================
          _buildDetailRow(
            'Shift Date & Hours',
            _formatShift(request),
            useLogicalPixels: !isMobilePortrait,
          ),

          SizedBox(height: detailGap),

          _buildDetailRow(
            'Station',
            request.station,
            useLogicalPixels: !isMobilePortrait,
          ),

          SizedBox(height: detailGap),

          _buildDetailRow(
            'Amount',
            '£${request.amount.toStringAsFixed(2)}',
            useLogicalPixels: !isMobilePortrait,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _buildDetailRow(
    String label,
    String value, {
    required bool useLogicalPixels,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        SizedBox(width: useLogicalPixels ? 16 : 12.w),

        Expanded(
          flex: 2,
          child: Text(
            value,
            style: AppTextStyles.bodyMd,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _buildStatusBadge(
    ShiftRequestStatus status, {
    required bool useLogicalPixels,
  }) {
    final (Color background, Color foreground, String label) = switch (status) {
      ShiftRequestStatus.pending => (
        AppColors.lightAccent,
        AppColors.background,
        'Pending',
      ),
      ShiftRequestStatus.accepted => (
        AppColors.primary,
        AppColors.background,
        'Accepted',
      ),
      ShiftRequestStatus.declined => (
        AppColors.surfaceContainer,
        AppColors.textSecondary,
        'Declined',
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: useLogicalPixels ? 12 : 10.w,
        vertical: useLogicalPixels ? 5 : 4.h,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(useLogicalPixels ? 20 : 20.r),
        border: status == ShiftRequestStatus.declined
            ? Border.all(color: AppColors.border)
            : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar(
    ShiftRequest request, {
    required double radius,
    required bool useLogicalPixels,
  }) {
    if (request.hairdresserPhotoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(request.hairdresserPhotoUrl!),
      );
    }

    final initials = request.hairdresserName
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
        style: AppTextStyles.labelLg.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // EMPTY STATES
  // ============================================================

  Widget _buildMobileEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Center(
        child: Text(
          'No requests in this category.',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLogicalEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Center(
        child: Text(
          'No requests in this category.',
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ============================================================
  // SHIFT FORMAT
  // ============================================================

  String _formatShift(ShiftRequest request) {
    final date = request.shiftDate;

    return '${date.day}/${date.month}/${date.year} '
        '• ${request.hours}';
  }
}

// ============================================================
// REQUEST CARD LAYOUT
// ============================================================

enum _RequestCardLayout {
  mobilePortrait,
  mobileLandscape,
  tabletPortrait,
  tabletLandscape,
}
