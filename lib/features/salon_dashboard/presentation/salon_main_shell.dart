import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/hairdresser_summary.dart';
import 'bookings_screen.dart';
import 'find_hairdressers_screen.dart';
import 'hairdresser_profile_screen.dart';
import 'requests_screen.dart';
import 'salon_dashboard_screen.dart';

class SalonMainShell extends StatefulWidget {
  const SalonMainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<SalonMainShell> createState() => _SalonMainShellState();
}

class _SalonMainShellState extends State<SalonMainShell> {
  late int _currentIndex = widget.initialIndex;

  bool _isSidebarOpen = true;

  HairdresserSummary? _selectedHairdresser;

  static const double _collapsedSidebarWidth = 64;
  static const double _expandedSidebarWidth = 190;

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  void _onNavigateToTab(int index) {
    if (index < 0 || index > 3) {
      return;
    }

    setState(() {
      _selectedHairdresser = null;
      _currentIndex = index;

      // Tablet par menu item select hone ke baad
      // expanded overlay close ho jayega.
      _isSidebarOpen = false;
    });
  }

  void _openHairdresserProfile(HairdresserSummary hairdresser) {
    if (_isTablet(context)) {
      setState(() {
        _selectedHairdresser = hairdresser;
        _currentIndex = 1;
        _isSidebarOpen = false;
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HairdresserProfileScreen(hairdresser: hairdresser),
      ),
    );
  }

  void _closeHairdresserProfile() {
    setState(() {
      _selectedHairdresser = null;
      _currentIndex = 1;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  List<Widget> _buildTabs() {
    return [
      SalonDashboardScreen(onNavigateToTab: _onNavigateToTab),

      FindHairdressersScreen(
        showBackButton: false,
        onHairdresserSelected: _openHairdresserProfile,
      ),

      const RequestsScreen(showBackButton: false),

      const BookingsScreen(showBackButton: false),
    ];
  }

  Widget _buildCurrentContent() {
    if (_currentIndex == 1 && _selectedHairdresser != null) {
      return HairdresserProfileScreen(
        hairdresser: _selectedHairdresser!,
        embeddedInTabletShell: true,
        onBack: _closeHairdresserProfile,
      );
    }

    final tabs = _buildTabs();

    return IndexedStack(index: _currentIndex, children: tabs);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = _isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: isTablet ? _buildTabletLayout() : _buildCurrentContent(),

      bottomNavigationBar: isTablet ? null : _buildMobileBottomNavigation(),
    );
  }

  // ============================================================
  // MOBILE BOTTOM NAVIGATION
  // ============================================================

  Widget _buildMobileBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavigateToTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surfaceContainer,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          iconSize: 24.sp,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: AppTextStyles.labelSm,
          unselectedLabelStyle: AppTextStyles.labelSm,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Stylists',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline),
              activeIcon: Icon(Icons.mail),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Bookings',
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TABLET LAYOUT
  // ============================================================

  Widget _buildTabletLayout() {
    return SafeArea(
      child: Stack(
        children: [
          // ------------------------------------------------------
          // BASE LAYOUT
          //
          // Sidebar ki collapsed width hamesha 64 rahegi.
          // Content sidebar open/close hone par resize nahi hoga.
          // ------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _collapsedSidebarWidth,
                child: _buildTabletSidebar(expanded: false),
              ),

              Container(width: 1, color: AppColors.border),

              Expanded(child: _buildCurrentContent()),
            ],
          ),

          // ------------------------------------------------------
          // EXPANDED DRAWER OVERLAY
          // ------------------------------------------------------
          if (_isSidebarOpen) ...[
            Positioned(
              left: _collapsedSidebarWidth,
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _toggleSidebar,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: AppColors.textPrimary.withValues(alpha: 0.08),
                ),
              ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              left: 0,
              top: 0,
              bottom: 0,
              width: _expandedSidebarWidth,
              child: Material(
                elevation: 8,
                child: _buildTabletSidebar(expanded: true),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // TABLET SIDEBAR
  // ============================================================

  Widget _buildTabletSidebar({required bool expanded}) {
    return Material(
      color: AppColors.surfaceContainer,
      child: Column(
        children: [
          SizedBox(
            height: 82,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: expanded ? 14 : 8),
              child: Row(
                children: [
                  if (expanded)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Maison Mayfair',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleSm.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Mayfair Atelier',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(
                    width: 42,
                    height: 42,
                    child: IconButton(
                      tooltip: expanded
                          ? 'Close navigation'
                          : 'Open navigation',
                      onPressed: _toggleSidebar,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        expanded ? Icons.menu_open_rounded : Icons.menu_rounded,
                        size: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(height: 1, color: AppColors.border),

          const SizedBox(height: 16),

          _buildSidebarItem(
            index: 0,
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
            expanded: expanded,
          ),

          const SizedBox(height: 5),

          _buildSidebarItem(
            index: 1,
            icon: Icons.search_outlined,
            selectedIcon: Icons.search,
            label: 'Stylists',
            expanded: expanded,
          ),

          const SizedBox(height: 5),

          _buildSidebarItem(
            index: 2,
            icon: Icons.mail_outline,
            selectedIcon: Icons.mail,
            label: 'Requests',
            expanded: expanded,
          ),

          const SizedBox(height: 5),

          _buildSidebarItem(
            index: 3,
            icon: Icons.calendar_today_outlined,
            selectedIcon: Icons.calendar_today,
            label: 'Bookings',
            expanded: expanded,
          ),

          const Spacer(),

          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 28, height: 2, color: AppColors.primary),
                    const SizedBox(height: 10),
                    Text(
                      'Beauty Connects\nOpportunities',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(width: 22, height: 2, color: AppColors.primary),
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool expanded,
  }) {
    final bool selected = _currentIndex == index;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: expanded ? 10 : 7),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onNavigateToTab(index),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 46,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: expanded ? 11 : 0),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: expanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    selected ? selectedIcon : icon,
                    size: 21,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),

                if (expanded) ...[
                  const SizedBox(width: 11),

                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
