enum ShiftRequestStatus { pending, accepted, declined }

/// A shift cover request sent to a hairdresser, as shown on the
/// Requests screen.
class ShiftRequest {
  const ShiftRequest({
    required this.id,
    required this.hairdresserName,
    required this.shiftDate,
    required this.hours,
    required this.station,
    required this.amount,
    required this.status,
    this.hairdresserPhotoUrl,
  });

  /// Booking reference, e.g. "YNK-4821".
  final String id;

  final String hairdresserName;

  /// Null when no photo is available yet — the UI falls back to a
  /// placeholder color avatar with the hairdresser's initials.
  final String? hairdresserPhotoUrl;

  final DateTime shiftDate;

  /// e.g. "09:30 - 18:00".
  final String hours;

  final String station;
  final double amount;
  final ShiftRequestStatus status;
}
