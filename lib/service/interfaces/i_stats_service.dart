import '../../models/stats.dart';
import '../../models/stats_average.dart';

/// Interface for the StatsService
abstract class IStatsService {
  /// Fetches statistics from the server
  /// 
  /// Returns a Stats object containing the statistics data
  Future<Stats> getStats();
  
  /// Fetches average statistics for a date range
  /// 
  /// Returns a StatsAverage object containing the averages data
  Future<StatsAverage> getAverages(String fromDate, String toDate);
}