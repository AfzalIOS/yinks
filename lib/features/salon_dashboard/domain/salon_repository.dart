import 'hairdresser_summary.dart';

/// Data source for the Salon Dashboard screen.
///
/// Abstracted so a real backend (Firebase) implementation can be
/// swapped in later without changing UI code.
abstract class SalonRepository {
  Future<List<HairdresserSummary>> getRecommendedHairdressers();

  Future<List<HairdresserSummary>> getAllHairdressers();

  Future<int> getActiveInvitesCount();

  Future<int> getUpcomingShiftsCount();
}
