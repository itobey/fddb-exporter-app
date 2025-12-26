import 'dart:io';

import 'package:fddb_exporter_app/service/correlation_service.dart';
import 'package:fddb_exporter_app/service/error_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_http.dart';

void main() {
  group('CorrelationService', () {
    test('fetchCorrelationData parses CorrelationsData on 200', () async {
      final endpoint = 'http://localhost:8080';
      final url = '$endpoint/api/v2/correlation';
      final overrides = FakeHttpOverrides({
        routeKey('POST', url): jsonOk({
          'correlations': {
            'across3Days': {'percentage': 10.0, 'matchedDates': [], 'matchedDays': 0},
            'across2Days': {'percentage': 20.0, 'matchedDates': [], 'matchedDays': 0},
            'sameDay': {'percentage': 30.0, 'matchedDates': [], 'matchedDays': 0},
            'oneDayBefore': {'percentage': 40.0, 'matchedDates': [], 'matchedDays': 0},
            'twoDaysBefore': {'percentage': 50.0, 'matchedDates': [], 'matchedDays': 0}
          },
          'matchedProducts': ['Banana'],
          'matchedDates': ['2025-08-15'],
          'amountMatchedProducts': 1,
          'amountMatchedDates': 1
        })
      });

      await HttpOverrides.runZoned(() async {
        final service = CorrelationService(errorService: ErrorService());
        final result = await service.fetchCorrelationData(
          inclusionKeywords: ['a'],
          exclusionKeywords: [],
          startDate: '2025-08-01',
          occurrenceDates: ['2025-08-15'],
        );
        expect(result.matchedProducts, contains('Banana'));
        expect(result.correlations.sameDay.percentage, 30.0);
      }, createHttpClient: (ctx) => overrides.createHttpClient(ctx));
    });
  });
}