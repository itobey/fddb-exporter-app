import 'dart:io';

import 'package:fddb_exporter_app/service/error_service.dart';
import 'package:fddb_exporter_app/service/stats_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_http.dart';

void main() {
  group('StatsService', () {
    test('getStats parses Stats on 200', () async {
      final endpoint = 'http://localhost:8080';
      final url = '$endpoint/api/v2/stats';
      final overrides = FakeHttpOverrides({
        routeKey('GET', url): jsonOk({
          'amountEntries': 100,
          'firstEntryDate': '2025-01-01T00:00:00.000',
          'mostRecentMissingDay': '2025-01-15T00:00:00.000',
          'entryPercentage': 95.5,
          'uniqueProducts': 150,
          'averageTotals': {
            'avgTotalCalories': 2000.0,
            'avgTotalFat': 70.0,
            'avgTotalCarbs': 250.0,
            'avgTotalSugar': 50.0,
            'avgTotalProtein': 90.0,
            'avgTotalFibre': 25.0
          },
          'highestCaloriesDay': { 'date': '2025-08-10T00:00:00.000', 'total': 3000.0 },
          'highestFatDay': { 'date': '2025-08-11T00:00:00.000', 'total': 120.0 },
          'highestCarbsDay': { 'date': '2025-08-12T00:00:00.000', 'total': 400.0 },
          'highestProteinDay': { 'date': '2025-08-13T00:00:00.000', 'total': 150.0 },
          'highestFibreDay': { 'date': '2025-08-14T00:00:00.000', 'total': 35.0 },
          'highestSugarDay': { 'date': '2025-08-15T00:00:00.000', 'total': 80.0 }
        })
      });

      await HttpOverrides.runZoned(() async {
        final service = StatsService(errorService: ErrorService());
        final stats = await service.getStats();
        expect(stats.amountEntries, 100);
        expect(stats.highestSugarDay.total, 80.0);
      }, createHttpClient: (ctx) => overrides.createHttpClient(ctx));
    });
  });
}