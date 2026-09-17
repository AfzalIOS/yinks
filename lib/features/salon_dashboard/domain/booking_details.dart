/// Shift details captured on the Book Shift form, passed through to the
/// Shift Request Sent confirmation screen.
class BookingDetails {
  const BookingDetails({
    required this.shiftDate,
    required this.hoursLabel,
    required this.station,
  });

  final DateTime shiftDate;

  /// e.g. "09:30 - 18:00".
  final String hoursLabel;

  final String station;
}
