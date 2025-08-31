import 'package:fddb_exporter_app/main.dart' as app;
import 'package:fddb_exporter_app/service/di/service_locator.dart';
import 'package:fddb_exporter_app/service/interfaces/i_correlation_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_daily_search_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_error_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_export_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_product_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_stats_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/mocks/mock_services.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Replace real services with mocks
    resetServiceLocator();
    getIt.registerLazySingleton<IErrorService>(() => MockErrorService());
    getIt.registerLazySingleton<IExportService>(() => MockExportService());
    getIt.registerLazySingleton<IProductService>(() => MockProductService());
    getIt.registerLazySingleton<IStatsService>(() => MockStatsService());
    getIt.registerLazySingleton<IDailySearchService>(() => MockDailySearchService());
    getIt.registerLazySingleton<ICorrelationService>(() => MockCorrelationService());
  });

  testWidgets('App starts and shows Export Data', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Export Data'), findsOneWidget);
    // Ensure we can tap Fetch Data without crashing using mocks
    final fetchBtn = find.widgetWithText(ElevatedButton, 'Fetch Data');
    expect(fetchBtn, findsOneWidget);
    await tester.tap(fetchBtn);
    await tester.pumpAndSettle();
  });
}
