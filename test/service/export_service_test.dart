import 'dart:io';

import 'package:fddb_exporter_app/service/error_service.dart';
import 'package:fddb_exporter_app/service/export_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_http.dart';

void main() {
  group('ExportService', () {
    test('fetchDataFromFirstEndpoint returns parsed data on 200', () async {
      final endpoint = 'http://localhost:8080';
      final url = '$endpoint/api/v2/fddbdata/export?days=7&includeToday=true';
      final overrides = FakeHttpOverrides({
        routeKey('GET', url): jsonOk({
          'successfulDays': ['2025-08-15'],
          'unsuccessfulDays': ['2025-08-14']
        })
      });

      await HttpOverrides.runZoned(() async {
        final service = ExportService(errorService: ErrorService());
        final result = await service.fetchDataFromFirstEndpoint(7, true);
        expect(result['successfulDays'], contains('2025-08-15'));
        expect(result['unsuccessfulDays'], contains('2025-08-14'));
      }, createHttpClient: (ctx) => overrides.createHttpClient(ctx));
    });

    test('fetchDataFromSecondEndpoint maps 500 to ServerError', () async {
      final endpoint = 'http://localhost:8080';
      final url = '$endpoint/api/v2/fddbdata';
      final overrides = FakeHttpOverrides({
        routeKey('POST', url): jsonWithStatus(500, {'message': 'server fail'})
      });

      await HttpOverrides.runZoned(() async {
        final service = ExportService(errorService: ErrorService());
        expect(
          () => service.fetchDataFromSecondEndpoint('2025-08-01', '2025-08-10'),
          throwsA(predicate((e) => e.runtimeType.toString() == 'ServerError')),
        );
      }, createHttpClient: (ctx) => overrides.createHttpClient(ctx));
    });
  });
}