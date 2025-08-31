/// Interface for the ExportService
abstract class IExportService {
  /// Fetches data from the first endpoint using days back and includeToday parameters
  /// 
  /// [days] The number of days to go back
  /// [includeToday] Whether to include today's data
  /// 
  /// Returns a Map containing the exported data
  Future<Map<String, dynamic>> fetchDataFromFirstEndpoint(int days, bool includeToday);

  /// Fetches data from the second endpoint using date range parameters
  /// 
  /// [fromDate] The start date in format YYYY-MM-DD
  /// [toDate] The end date in format YYYY-MM-DD
  /// 
  /// Returns a Map containing the exported data
  Future<Map<String, dynamic>> fetchDataFromSecondEndpoint(String fromDate, String toDate);
}