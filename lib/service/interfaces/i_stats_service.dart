import '../../models/stats.dart';

/// Interface for the StatsService
abstract class IStatsService {
  /// Fetches statistics from the server
  /// 
  /// Returns a Stats object containing the statistics data
  Future<Stats> getStats();
}