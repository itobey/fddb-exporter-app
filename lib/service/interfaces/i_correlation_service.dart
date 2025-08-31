import '../../models/correlations.dart';

/// Interface for the CorrelationService
abstract class ICorrelationService {
  /// Fetches correlation data based on the provided parameters
  /// 
  /// [inclusionKeywords] List of keywords to include in the correlation
  /// [exclusionKeywords] List of keywords to exclude from the correlation
  /// [startDate] The start date for the correlation analysis
  /// [occurrenceDates] List of dates when occurrences happened
  /// 
  /// Returns a CorrelationsData object containing the correlation results
  Future<CorrelationsData> fetchCorrelationData({
    required List<String> inclusionKeywords,
    required List<String> exclusionKeywords,
    required String startDate,
    required List<String> occurrenceDates,
  });
}