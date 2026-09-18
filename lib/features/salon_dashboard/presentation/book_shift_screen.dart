import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/booking_details.dart';
import '../domain/hairdresser_summary.dart';
import 'shift_request_sent_screen.dart';

const List<String> _stationOptions = [
  'Chair 01 (Senior Cutting Station)',
  'Chair 03 (Color Bar & Balayage Station)',
  'VIP Private Suite',
];

class BookShiftScreen extends StatefulWidget {
  const BookShiftScreen({super.key, required this.hairdresser});

  final HairdresserSummary hairdresser;

  @override
  State<BookShiftScreen> createState() => _BookShiftScreenState();
}

class _BookShiftScreenState extends State<BookShiftScreen> {
  DateTime? _shiftDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _station;

  final TextEditingController _notesController = TextEditingController();

  // ============================================================
  // DEVICE CHECKS
  // ============================================================

  bool _isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= 600;
  }

  bool _isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  // ============================================================
  // CLEANUP
  // ============================================================

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ============================================================
  // HOURS LABEL
  // ============================================================

  String get _hoursLabel {
    if (_startTime == null || _endTime == null) {
      return '';
    }

    return '${_startTime!.format(context)} - '
        '${_endTime!.format(context)}';
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _shiftDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _shiftDate = picked;
      });
    }
  }

  // ============================================================
  // START TIME
  // ============================================================

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 30),
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  // ============================================================
  // END TIME
  // ============================================================

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 18, minute: 0),
    );

    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  // ============================================================
  // HOURS PICKER
  // ============================================================

  Future<void> _pickHours() async {
    await _pickStartTime();

    if (!mounted) {
      return;
    }

    await _pickEndTime();
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  void _submitShiftRequest() {
    final hairdresser = widget.hairdresser;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShiftRequestSentScreen(
          hairdresser: hairdresser,
          details: BookingDetails(
            shiftDate: _shiftDate ?? DateTime.now(),
            hoursLabel: _hoursLabel.isEmpty ? 'Not set' : _hoursLabel,
            station: _station ?? 'Not assigned',
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isTablet = _isTablet(context);
    final bool isLandscape = _isLandscape(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(isLandscape: isLandscape)
            : _buildMobileLayout(isLandscape: isLandscape),
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileLayout({required bool isLandscape}) {
    if (isLandscape) {
      return _buildMobileLandscape();
    }

    return _buildMobilePortrait();
  }

  // ============================================================
  // MOBILE PORTRAIT
  // Existing mobile design preserved
  // ============================================================

  Widget _buildMobilePortrait() {
    final hairdresser = widget.hairdresser;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMobileBackButton(),

          SizedBox(height: 8.h),

          Text('Request Shift Cover', style: AppTextStyles.headlineSm),

          SizedBox(height: 20.h),

          _buildMobileHairdresserSummary(hairdresser),

          SizedBox(height: 24.h),

          _buildMobileLabel('Shift Date'),

          GestureDetector(
            onTap: _pickDate,
            child: _buildMobileFieldBox(
              text: _shiftDate == null
                  ? null
                  : '${_shiftDate!.day}/'
                        '${_shiftDate!.month}/'
                        '${_shiftDate!.year}',
              hintText: 'Select date',
              trailingIcon: Icons.calendar_today_outlined,
            ),
          ),

          SizedBox(height: 16.h),

          _buildMobileLabel('Shift Hours'),

          GestureDetector(
            onTap: _pickHours,
            child: _buildMobileFieldBox(
              text: _hoursLabel.isEmpty ? null : _hoursLabel,
              hintText: 'Select hours',
              trailingIcon: Icons.access_time_outlined,
            ),
          ),

          SizedBox(height: 16.h),

          _buildMobileLabel('Assigned Station'),

          DropdownButtonFormField<String>(
            initialValue: _station,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
            hint: Text(
              'Select station',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            style: AppTextStyles.bodyMd,
            decoration: _mobileInputDecoration(),
            items: _stationOptions
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _station = value;
              });
            },
          ),

          SizedBox(height: 16.h),

          _buildMobileLabel('Salon Notes for Stylist'),

          TextField(
            controller: _notesController,
            maxLines: 4,
            style: AppTextStyles.bodyMd,
            decoration: _mobileInputDecoration(
              hintText: 'Add any notes for the hairdresser...',
            ),
          ),

          SizedBox(height: 24.h),

          _buildMobilePayoutCard(),

          SizedBox(height: 24.h),

          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: _submitShiftRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Confirm & Send Shift Request',
                style: AppTextStyles.titleMd.copyWith(
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE LANDSCAPE
  // No drawer
  // Logical pixels to avoid ScreenUtil over-scaling
  // ============================================================

  Widget _buildMobileLandscape() {
    final hairdresser = widget.hairdresser;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogicalBackButton(),

              const SizedBox(height: 6),

              Text('Request Shift Cover', style: AppTextStyles.headlineSm),

              const SizedBox(height: 18),

              _buildLogicalHairdresserSummary(hairdresser, compact: true),

              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLogicalLabel('Shift Date'),
                        GestureDetector(
                          onTap: _pickDate,
                          child: _buildLogicalFieldBox(
                            text: _shiftDate == null
                                ? null
                                : '${_shiftDate!.day}/'
                                      '${_shiftDate!.month}/'
                                      '${_shiftDate!.year}',
                            hintText: 'Select date',
                            trailingIcon: Icons.calendar_today_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLogicalLabel('Shift Hours'),
                        GestureDetector(
                          onTap: _pickHours,
                          child: _buildLogicalFieldBox(
                            text: _hoursLabel.isEmpty ? null : _hoursLabel,
                            hintText: 'Select hours',
                            trailingIcon: Icons.access_time_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildLogicalLabel('Assigned Station'),

              _buildLogicalStationDropdown(),

              const SizedBox(height: 16),

              _buildLogicalLabel('Salon Notes for Stylist'),

              TextField(
                controller: _notesController,
                maxLines: 3,
                style: AppTextStyles.bodyMd,
                decoration: _logicalInputDecoration(
                  hintText: 'Add any notes for the hairdresser...',
                ),
              ),

              const SizedBox(height: 20),

              _buildLogicalPayoutCard(),

              const SizedBox(height: 18),

              _buildLogicalSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TABLET
  // No drawer on portrait or landscape
  // ============================================================

  Widget _buildTabletLayout({required bool isLandscape}) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isLandscape ? 48 : 36,
        28,
        isLandscape ? 48 : 36,
        40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isLandscape ? 1100 : 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogicalBackButton(),

              const SizedBox(height: 14),

              Text('Request Shift Cover', style: AppTextStyles.headlineSm),

              const SizedBox(height: 24),

              _buildLogicalHairdresserSummary(widget.hairdresser),

              const SizedBox(height: 28),

              if (isLandscape)
                _buildTabletLandscapeFields()
              else
                _buildTabletPortraitFields(),

              const SizedBox(height: 18),

              _buildLogicalLabel('Assigned Station'),

              _buildLogicalStationDropdown(),

              const SizedBox(height: 18),

              _buildLogicalLabel('Salon Notes for Stylist'),

              TextField(
                controller: _notesController,
                maxLines: isLandscape ? 4 : 4,
                style: AppTextStyles.bodyMd,
                decoration: _logicalInputDecoration(
                  hintText: 'Add any notes for the hairdresser...',
                ),
              ),

              const SizedBox(height: 26),

              _buildLogicalPayoutCard(),

              const SizedBox(height: 22),

              _buildLogicalSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TABLET PORTRAIT DATE + HOURS
  // ============================================================

  Widget _buildTabletPortraitFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogicalLabel('Shift Date'),

        GestureDetector(
          onTap: _pickDate,
          child: _buildLogicalFieldBox(
            text: _shiftDate == null
                ? null
                : '${_shiftDate!.day}/'
                      '${_shiftDate!.month}/'
                      '${_shiftDate!.year}',
            hintText: 'Select date',
            trailingIcon: Icons.calendar_today_outlined,
          ),
        ),

        const SizedBox(height: 18),

        _buildLogicalLabel('Shift Hours'),

        GestureDetector(
          onTap: _pickHours,
          child: _buildLogicalFieldBox(
            text: _hoursLabel.isEmpty ? null : _hoursLabel,
            hintText: 'Select hours',
            trailingIcon: Icons.access_time_outlined,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TABLET LANDSCAPE DATE + HOURS
  // ============================================================

  Widget _buildTabletLandscapeFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogicalLabel('Shift Date'),

              GestureDetector(
                onTap: _pickDate,
                child: _buildLogicalFieldBox(
                  text: _shiftDate == null
                      ? null
                      : '${_shiftDate!.day}/'
                            '${_shiftDate!.month}/'
                            '${_shiftDate!.year}',
                  hintText: 'Select date',
                  trailingIcon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogicalLabel('Shift Hours'),

              GestureDetector(
                onTap: _pickHours,
                child: _buildLogicalFieldBox(
                  text: _hoursLabel.isEmpty ? null : _hoursLabel,
                  hintText: 'Select hours',
                  trailingIcon: Icons.access_time_outlined,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE HELPERS
  // ============================================================

  Widget _buildMobileBackButton() {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildMobileHairdresserSummary(HairdresserSummary hairdresser) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildMobileAvatar(hairdresser),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${hairdresser.name} '
                  '(${hairdresser.specialty})',
                  style: AppTextStyles.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 2.h),

                Text(
                  '£${hairdresser.ratePerDay.toStringAsFixed(2)} '
                  '/ Full Day',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: AppTextStyles.labelLg),
    );
  }

  Widget _buildMobileFieldBox({
    required String? text,
    required String hintText,
    required IconData trailingIcon,
  }) {
    return Container(
      width: double.infinity,
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text ?? hintText,
              style: AppTextStyles.bodyMd.copyWith(
                color: text == null
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Icon(trailingIcon, size: 20.sp, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  InputDecoration _mobileInputDecoration({String? hintText}) {
    final radius = BorderRadius.circular(8.r);

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceContainer,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildMobilePayoutCard() {
    final hairdresser = widget.hairdresser;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agreed Payout: '
            '£${hairdresser.ratePerDay.toStringAsFixed(2)}',
            style: AppTextStyles.titleSm,
          ),

          SizedBox(height: 6.h),

          Text(
            'Funds are held securely and released only after '
            'shift completion.',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAvatar(HairdresserSummary hairdresser) {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: 24.r,
        backgroundImage: NetworkImage(hairdresser.photoUrl!),
      );
    }

    return CircleAvatar(
      radius: 24.r,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        _getInitials(hairdresser.name),
        style: AppTextStyles.titleSm.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // LOGICAL PIXEL HELPERS
  // Used by phone landscape + tablets
  // ============================================================

  Widget _buildLogicalBackButton() {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }

  Widget _buildLogicalHairdresserSummary(
    HairdresserSummary hairdresser, {
    bool compact = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 20,
        vertical: compact ? 14 : 18,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildLogicalAvatar(hairdresser, radius: compact ? 25 : 32),

          SizedBox(width: compact ? 14 : 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${hairdresser.name} '
                  '(${hairdresser.specialty})',
                  style: AppTextStyles.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  '£${hairdresser.ratePerDay.toStringAsFixed(2)} '
                  '/ Full Day',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogicalLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTextStyles.labelLg),
    );
  }

  Widget _buildLogicalFieldBox({
    required String? text,
    required String hintText,
    required IconData trailingIcon,
  }) {
    return Container(
      width: double.infinity,
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text ?? hintText,
              style: AppTextStyles.bodyMd.copyWith(
                color: text == null
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Icon(trailingIcon, size: 21, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildLogicalStationDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _station,
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.textSecondary,
        size: 22,
      ),
      hint: Text(
        'Select station',
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),
      style: AppTextStyles.bodyMd,
      decoration: _logicalInputDecoration(),
      items: _stationOptions
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(option, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _station = value;
        });
      },
    );
  }

  InputDecoration _logicalInputDecoration({String? hintText}) {
    const radius = BorderRadius.all(Radius.circular(9));

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildLogicalPayoutCard() {
    final hairdresser = widget.hairdresser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agreed Payout: '
            '£${hairdresser.ratePerDay.toStringAsFixed(2)}',
            style: AppTextStyles.titleSm,
          ),

          const SizedBox(height: 6),

          Text(
            'Funds are held securely and released only after '
            'shift completion.',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogicalSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _submitShiftRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Text(
          'Confirm & Send Shift Request',
          style: AppTextStyles.titleMd.copyWith(color: AppColors.background),
        ),
      ),
    );
  }

  Widget _buildLogicalAvatar(
    HairdresserSummary hairdresser, {
    required double radius,
  }) {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(hairdresser.photoUrl!),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        _getInitials(hairdresser.name),
        style: AppTextStyles.titleSm.copyWith(color: AppColors.background),
      ),
    );
  }

  // ============================================================
  // INITIALS
  // ============================================================

  String _getInitials(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }
}
