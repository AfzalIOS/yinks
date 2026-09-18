import 'opportunity_summary.dart';

/// Data source for the Hairdresser Dashboard screen.
///
/// Abstracted so a real backend (Firebase) implementation can be
/// swapped in later without changing UI code.
abstract class HairdresserRepository {
  Future<List<OpportunitySummary>> getRecommendedOpportunities();

  Future<List<OpportunitySummary>> getAllOpportunities();

  Future<int> getNewOpportunitiesCount();

  Future<int> getActiveApplicationsCount();
}
