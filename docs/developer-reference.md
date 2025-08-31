# Developer Reference

This reference provides an overview of key classes and methods in the app.

Note: Detailed API and models are documented in docs/api.md. Architecture is described in docs/architecture.md.

## Providers

- ExportProvider (lib/providers/export_provider.dart)
  - fetchDataByDays(int days, bool includeToday): triggers GET export
  - fetchDataByDateRange(DateTime from, DateTime to): triggers POST export
  - clearData(): reset response
  - showErrorDialog/ showErrorSnackBar: present current error

## Services

- ExportService (lib/service/export_service.dart)
  - fetchDataFromFirstEndpoint(int days, bool includeToday): GET /fddbdata/export
  - fetchDataFromSecondEndpoint(String fromDate, String toDate): POST /fddbdata

- DailySearchService (lib/service/daily_search_service.dart)
  - fetchDailyNutrition(DateTime date): GET /fddbdata/{date}

- ProductService (lib/service/product_service.dart)
  - fetchProducts(String name): GET /fddbdata/products?name={name}

- StatsService (lib/service/stats_service.dart)
  - getStats(): GET /fddbdata/stats

- CorrelationService (lib/service/correlation_service.dart)
  - fetchCorrelationData({inclusionKeywords, exclusionKeywords, startDate, occurrenceDates}): POST /correlation

- ErrorService (lib/service/error_service.dart)
  - handleError(dynamic error, [StackTrace? stackTrace]): maps to AppError
  - getUserFriendlyMessage(AppError): string for UI
  - showErrorDialog/ showErrorSnackBar: UI helpers

## Models (selected)

- AppError and subtypes: NetworkError, TimeoutError, ServerError, ClientError, ParseError, ValidationError
- DailyResult, ProductSearchResult, Product, Stats, CorrelationsData, ExportStatus

## Routing

- route_generator.dart defines routes for screens and argument handling

## DI

- getIt registration under lib/service/di/service_locator.dart

## Shared Widgets

- CardSection, CustomDivider, StatItem, StatRow, ProductCard

## Utilities

- url_launcher.dart: helpers to open URLs

## Testing

- Unit tests in test/service/* for services
- Widget tests under test/*_widget_test.dart
- Integration test under integration_test/
