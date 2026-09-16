import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../domain/hairdresser_summary.dart';

const List<String> _stationOptions = [
  'Chair 01 (Senior Cutting Station)',
  'Chair 03 (Color Bar & Balayage Station)',
  'VIP Private Suite',
];

/// Request Shift Cover form for a single [HairdresserSummary]. No real
/// booking/payment logic yet — submitting is a no-op for now.
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

  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String get _hoursLabel {
    if (_startTime == null || _endTime == null) return '';
    return '${_startTime!.format(context)} - ${_endTime!.format(context)}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _shiftDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _shiftDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 30),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final hairdresser = widget.hairdresser;
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
              SizedBox(height: 8.h),
              Text('Request Shift Cover', style: AppTextStyles.headlineSm),
              SizedBox(height: 20.h),
              _buildHairdresserSummary(hairdresser),
              SizedBox(height: 24.h),
              _buildLabel('Shift Date'),
              GestureDetector(
                onTap: _pickDate,
                child: _buildFieldBox(
                  text: _shiftDate == null
                      ? null
                      : '${_shiftDate!.day}/${_shiftDate!.month}/'
                            '${_shiftDate!.year}',
                  hintText: 'Select date',
                  trailingIcon: Icons.calendar_today_outlined,
                ),
              ),
              SizedBox(height: 16.h),
              _buildLabel('Shift Hours'),
              GestureDetector(
                onTap: () async {
                  await _pickStartTime();
                  if (!context.mounted) return;
                  await _pickEndTime();
                },
                child: _buildFieldBox(
                  text: _hoursLabel.isEmpty ? null : _hoursLabel,
                  hintText: 'Select hours',
                  trailingIcon: Icons.access_time_outlined,
                ),
              ),
              SizedBox(height: 16.h),
              _buildLabel('Assigned Station'),
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
                decoration: _inputDecoration(),
                items: _stationOptions
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _station = value),
              ),
              SizedBox(height: 16.h),
              _buildLabel('Salon Notes for Stylist'),
              TextField(
                controller: _notesController,
                maxLines: 4,
                style: AppTextStyles.bodyMd,
                decoration: _inputDecoration(
                  hintText: 'Add any notes for the hairdresser...',
                ),
              ),
              SizedBox(height: 24.h),
              Container(
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
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  // Will navigate to a confirmation screen once built.
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
        ),
      ),
    );
  }

  Widget _buildHairdresserSummary(HairdresserSummary hairdresser) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildAvatar(hairdresser),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${hairdresser.name} (${hairdresser.specialty})',
                  style: AppTextStyles.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  '£${hairdresser.ratePerDay.toStringAsFixed(2)} / Full Day',
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: AppTextStyles.labelLg),
    );
  }

  Widget _buildFieldBox({
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

  InputDecoration _inputDecoration({String? hintText}) {
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

  Widget _buildAvatar(HairdresserSummary hairdresser) {
    if (hairdresser.photoUrl != null) {
      return CircleAvatar(
        radius: 24.r,
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
      radius: 24.r,
      backgroundColor: AppColors.lightAccent,
      child: Text(
        initials,
        style: AppTextStyles.titleSm.copyWith(color: AppColors.background),
      ),
    );
  }
}
