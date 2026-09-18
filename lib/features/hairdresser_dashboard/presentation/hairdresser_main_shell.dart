import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'availability_screen.dart';
import 'hairdresser_dashboard_screen.dart';
import 'my_applications_screen.dart';
import 'opportunities_screen.dart';

/// Persistent navigation shell for the Hairdresser side of the app.
/// Mirrors SalonMainShell: an IndexedStack of 4 root tabs, a bottom
/// nav bar on mobile, and — on tablet — a fixed-width collapsed icon
/// rail whose expanded state is an overlay on top of the content
/// (never resizing it) rather than a resize of the rail itself.
///
/// Root tab screens never add their own sidebar/bottom-nav — only this
/// shell owns navigation.
class HairdresserMainShell extends StatefulWidget {
  const HairdresserMainShell({super.key, this.initialIndex = 0});

  /// Which tab to start on, e.g. 1 to land directly on Opportunities.
  final int initialIndex;

  @override
  State<HairdresserMainShell> createState() => _HairdresserMainShellState();
}

class _HairdresserMainShellState extends State<HairdresserMainShell> {
  late int _currentIndex = widget.initialIndex;

  bool _isSidebarOpen = true;

  static const double _collapsedSidebarWidth = 64;
  static const double _expandedSidebarWidth = 190;

  late final List<Widget> _tabs = [
    HairdresserDashboardScreen(onNavigateToTab: _onNavigateToTab),
    const OpportunitiesScreen(),
    const MyApplicationsScreen(),
    const AvailabilityScreen(),
  ];

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  void _onNavigateToTab(int index) {
    if (index < 0 || index >= _tabs.length) {
      return;
    }

    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;

      // Tablet: close the expanded overlay after picking a menu item.
      _isSidebarOpen = false;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = _isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: isTablet
          ? _buildTabletLayout()
          : IndexedStack(index: _currentIndex, children: _tabs),

      // MOBILE ONLY
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
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Opportunities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Applications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Availability',
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
          // The sidebar slot here is ALWAYS the fixed collapsed
          // width — it never animates or resizes, so the Expanded
          // content next to it never resizes/jumps when the sidebar
          // is toggled. Same fix as SalonMainShell.
          // ------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _collapsedSidebarWidth,
                child: _buildTabletSidebar(expanded: false),
              ),

              Container(width: 1, color: AppColors.border),

              Expanded(
                child: IndexedStack(index: _currentIndex, children: _tabs),
              ),
            ],
          ),

          // ------------------------------------------------------
          // EXPANDED DRAWER OVERLAY
          //
          // Floats on top of the fixed layout above instead of
          // resizing it. A translucent tap-catcher over the content
          // area lets tapping outside the drawer close it.
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
                            'Chloe Laurent',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleSm.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Senior Colourist',
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
            icon: Icons.work_outline,
            selectedIcon: Icons.work,
            label: 'Opportunities',
            expanded: expanded,
          ),

          const SizedBox(height: 5),

          _buildSidebarItem(
            index: 2,
            icon: Icons.assignment_outlined,
            selectedIcon: Icons.assignment,
            label: 'Applications',
            expanded: expanded,
          ),

          const SizedBox(height: 5),

          _buildSidebarItem(
            index: 3,
            icon: Icons.calendar_today_outlined,
            selectedIcon: Icons.calendar_today,
            label: 'Availability',
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
