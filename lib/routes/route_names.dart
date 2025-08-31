/// Constants for route names to avoid typos and make refactoring easier
class RouteNames {
  // Private constructor to prevent instantiation
  RouteNames._();
  
  // Home/default route
  static const String home = '/';
  
  // Main feature routes
  static const String dailySearch = '/fddb-daily';
  static const String exportData = '/fddb-export';
  static const String productSearch = '/fddb-product';
  static const String stats = '/fddb-stats';
  static const String correlation = '/correlation';
  static const String settings = '/settings';
}