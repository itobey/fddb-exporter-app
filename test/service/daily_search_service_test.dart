import 'dart:io';

import 'package:fddb_exporter_app/service/daily_search_service.dart';
import 'package:fddb_exporter_app/service/error_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_http.dart';

void main() {
  group('DailySearchService', () {
    test('fetchDailyNutrition parses DailyResult on 200', () async {
      final endpoint = 'http://localhost:8080';
      final date = DateTime(2025, 8, 15);
      final url = '$endpoint/api/v1/fddbdata/2025-08-15';
      final overrides = FakeHttpOverrides({
        routeKey('GET', url): jsonOk({
          'date': '2025-08-15T00:00:00.000',
          'products': [
            {
              'name': 'Banana',
              'amount': '100g',
              'calories': 89.0,
              'fat': 0.3,
              'carbs': 23.0,
              'protein': 1.1,
              'link': 'https://example.com/banana'
            }
          ],
          'totalCalories': 89.0,
          'totalFat': 0.3,
          'totalCarbs': 23.0,
          'totalSugar': 12.0,
          'totalProtein': 1.1,
          'totalFibre': 2.6
        })
      });

      await HttpOverrides.runZoned(() async {
        final service = DailySearchService(errorService: ErrorService());
        final result = await service.fetchDailyNutrition(date);
        expect(result.totalCalories, 89.0);
        expect(result.products.first.name, 'Banana');
      }, createHttpClient: (ctx) => overrides.createHttpClient(ctx));
    });
  });
}