import 'dart:io';

import 'package:fddb_exporter_app/service/error_service.dart';
import 'package:fddb_exporter_app/service/product_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_http.dart';

void main() {
  group('ProductService', () {
    test('fetchProducts parses list on 200', () async {
      final endpoint = 'http://localhost:8080';
      final url = '$endpoint/api/v2/fddbdata/products?name=banana';
      final overrides = FakeHttpOverrides({
        routeKey('GET', url): jsonOk([
          {
            'date': '2025-08-15T00:00:00.000',
            'product': {
              'name': 'Banana',
              'amount': '100g',
              'calories': 89.0,
              'fat': 0.3,
              'carbs': 23.0,
              'protein': 1.1,
              'link': 'https://example.com/banana'
            }
          }
        ])
      });

      await HttpOverrides.runZoned(() async {
        final service = ProductService(errorService: ErrorService());
        final list = await service.fetchProducts('banana');
        expect(list, isNotEmpty);
        expect(list.first.product.name, 'Banana');
      }, createHttpClient: (ctx) => overrides.createHttpClient(ctx));
    });
  });
}