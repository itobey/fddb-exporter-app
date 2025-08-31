import 'package:fddb_exporter_app/providers/export_provider.dart';
import 'package:fddb_exporter_app/service/di/service_locator.dart';
import 'package:fddb_exporter_app/service/interfaces/i_error_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_export_service.dart';
import 'package:fddb_exporter_app/widgets/export_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mocks/mock_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await getIt.reset();
    getIt.registerLazySingleton<IErrorService>(() => MockErrorService());
    getIt.registerLazySingleton<IExportService>(() => MockExportService());
  });

  testWidgets('ExportDataWidget displays initial state correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => ExportProvider(),
          child: const ExportDataWidget(),
        ),
      ),
    );

    expect(find.text('Export Data'), findsOneWidget);
    expect(find.text('Days Back'), findsOneWidget);
    expect(find.text('Timeframe'), findsOneWidget);
    expect(find.text('Number of days'), findsOneWidget);
    expect(find.text('Include today'), findsOneWidget);
    expect(find.text('Fetch Data'), findsOneWidget);
    expect(find.text('No data fetched yet.'), findsOneWidget);
  });
}