import 'package:get_it/get_it.dart';

import '../correlation_service.dart';
import '../daily_search_service.dart';
import '../error_service.dart';
import '../export_service.dart';
import '../interfaces/i_correlation_service.dart';
import '../interfaces/i_daily_search_service.dart';
import '../interfaces/i_error_service.dart';
import '../interfaces/i_export_service.dart';
import '../interfaces/i_product_service.dart';
import '../interfaces/i_stats_service.dart';
import '../product_service.dart';
import '../stats_service.dart';

/// Global GetIt instance for dependency injection
final GetIt getIt = GetIt.instance;

/// Setup function to register all services
void setupServiceLocator() {
  // Register services as singletons
  
  // ErrorService - register as singleton
  getIt.registerLazySingleton<IErrorService>(() => ErrorService());
  
  // ExportService - register as singleton with dependencies
  getIt.registerLazySingleton<IExportService>(
    () => ExportService(errorService: getIt<IErrorService>())
  );
  
  // CorrelationService - register as singleton with dependencies
  getIt.registerLazySingleton<ICorrelationService>(
    () => CorrelationService(errorService: getIt<IErrorService>())
  );
  
  // DailySearchService - register as singleton with dependencies
  getIt.registerLazySingleton<IDailySearchService>(
    () => DailySearchService(errorService: getIt<IErrorService>())
  );
  
  // ProductService - register as singleton with dependencies
  getIt.registerLazySingleton<IProductService>(
    () => ProductService(errorService: getIt<IErrorService>())
  );
  
  // StatsService - register as singleton with dependencies
  getIt.registerLazySingleton<IStatsService>(
    () => StatsService(errorService: getIt<IErrorService>())
  );
}

/// Reset all registered services (useful for testing)
void resetServiceLocator() {
  getIt.reset();
}