import '../../models/daily_result.dart';

/// Interface for the DailySearchService
abstract class IDailySearchService {
  /// Fetches daily nutrition data for a specific date
  /// 
  /// [date] The date for which to fetch nutrition data
  /// 
  /// Returns a DailyResult object containing the nutrition data for the specified date
  Future<DailyResult> fetchDailyNutrition(DateTime date);
}