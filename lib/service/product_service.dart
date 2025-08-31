import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/app_error.dart';
import '../models/product_search_result.dart';
import 'error_service.dart';
import 'interfaces/i_error_service.dart';
import 'interfaces/i_product_service.dart';

class ProductService implements IProductService {
  final IErrorService _errorService;
  
  /// Creates a ProductService with the given ErrorService
  ProductService({required IErrorService errorService}) : _errorService = errorService;
  
  /// Search products by name substring.
  /// Returns a list of ProductSearchResult from GET /fddbdata/products?name=
  Future<List<ProductSearchResult>> fetchProducts(String name) async {
    late String endpoint;
    String? url;
    
    try {
      endpoint = await Config.getEndpoint();
      url = '$endpoint/api/v1/fddbdata/products?name=$name';
      
      final response = await http.get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        try {
          final decodedData = utf8.decode(response.bodyBytes);
          final List<dynamic> jsonResponse = json.decode(decodedData);
          return jsonResponse.map((data) => ProductSearchResult.fromJson(data)).toList();
        } catch (e, stackTrace) {
          throw _errorService.handleError(
            ParseError(
              message: 'Failed to parse product data',
              data: response.body,
              stackTrace: stackTrace,
            )
          );
        }
      } else if (response.statusCode >= 500) {
        throw _errorService.handleError(
          ServerError(
            message: 'Server error occurred while fetching products',
            statusCode: response.statusCode,
            url: url,
          )
        );
      } else if (response.statusCode >= 400) {
        throw _errorService.handleError(
          ClientError(
            message: 'Client error occurred while fetching products',
            statusCode: response.statusCode,
            url: url,
          )
        );
      } else {
        throw _errorService.handleError(
          NetworkError(
            message: 'Unexpected status code: ${response.statusCode}',
            statusCode: response.statusCode,
            url: url,
          )
        );
      }
    } catch (e, stackTrace) {
      if (e is AppError) {
        rethrow;
      } else if (e is SocketException) {
        throw _errorService.handleError(
          NetworkError(
            message: 'Network connection error while fetching products',
            url: url,
            stackTrace: stackTrace,
          )
        );
      } else if (e is TimeoutException) {
        throw _errorService.handleError(
          TimeoutError(
            message: 'Request timed out while fetching products',
            url: url,
            timeoutInSeconds: 30,
            stackTrace: stackTrace,
          )
        );
      } else {
        throw _errorService.handleError(e, stackTrace);
      }
    }
  }
}
