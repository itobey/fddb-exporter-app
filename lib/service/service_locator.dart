import '../service/correlation_service.dart';
import '../service/daily_search_service.dart';
import '../service/error_service.dart';
import '../service/export_service.dart';
import '../service/product_service.dart';
import '../service/stats_service.dart';

/// A simple service locator for dependency injection
class ServiceLocator {
  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._internal();
  
  // Factory constructor
  factory ServiceLocator() => _instance;
  
  // Private constructor
  ServiceLocator._internal();
  
  // Service instances
  final ErrorService _errorService = ErrorService();
  ExportService? _exportService;
  CorrelationService? _correlationService;
  DailySearchService? _dailySearchService;
  ProductService? _productService;
  StatsService? _statsService;
  
  /// Get the ErrorService instance
  ErrorService get errorService => _errorService;
  
  /// Get the ExportService instance
  ExportService get exportService {
    _exportService ??= ExportService(errorService: _errorService);
    return _exportService!;
  }
  
  /// Get the CorrelationService instance
  CorrelationService get correlationService {
    _correlationService ??= CorrelationService(errorService: _errorService);
    return _correlationService!;
  }
  
  /// Get the DailySearchService instance
  DailySearchService get dailySearchService {
    _dailySearchService ??= DailySearchService(errorService: _errorService);
    return _dailySearchService!;
  }
  
  /// Get the ProductService instance
  ProductService get productService {
    _productService ??= ProductService(errorService: _errorService);
    return _productService!;
  }
  
  /// Get the StatsService instance
  StatsService get statsService {
    _statsService ??= StatsService(errorService: _errorService);
    return _statsService!;
  }
  
  /// Reset all service instances (useful for testing)
  void reset() {
    _exportService = null;
    _correlationService = null;
    _dailySearchService = null;
    _productService = null;
    _statsService = null;
  }
}