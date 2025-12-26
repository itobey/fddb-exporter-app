import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../config.dart';
import '../models/app_error.dart';
import '../models/correlations.dart';
import 'error_service.dart';
import 'interfaces/i_correlation_service.dart';
import 'interfaces/i_error_service.dart';
import 'package:http/http.dart' as http;

class CorrelationService implements ICorrelationService {
  final IErrorService _errorService;
  
  /// Creates a CorrelationService with the given ErrorService
  CorrelationService({required IErrorService errorService}) : _errorService = errorService;
  
  /// Request correlation analysis for the given parameters.
  /// Sends inclusion/exclusion keywords, optional startDate, and occurrenceDates.
  Future<CorrelationsData> fetchCorrelationData({
    required List<String> inclusionKeywords,
    required List<String> exclusionKeywords,
    required String startDate,
    required List<String> occurrenceDates,
  }) async {
    late String endpoint;
    String? url;
    
    try {
      endpoint = await Config.getEndpoint();
      url = '$endpoint/api/v2/correlation';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'inclusionKeywords': inclusionKeywords,
          'exclusionKeywords': exclusionKeywords,
          'startDate': startDate,
          'occurrenceDates': occurrenceDates,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        try {
          final decodedData = utf8.decode(response.bodyBytes);
          return CorrelationsData.fromJson(json.decode(decodedData));
        } catch (e, stackTrace) {
          throw _errorService.handleError(
            ParseError(
              message: 'Failed to parse correlation data',
              data: response.body,
              stackTrace: stackTrace,
            )
          );
        }
      } else if (response.statusCode >= 500) {
        throw _errorService.handleError(
          ServerError(
            message: 'Server error occurred while fetching correlation data',
            statusCode: response.statusCode,
            url: url,
          )
        );
      } else if (response.statusCode >= 400) {
        throw _errorService.handleError(
          ClientError(
            message: 'Client error occurred while fetching correlation data',
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
            message: 'Network connection error while fetching correlation data',
            url: url,
            stackTrace: stackTrace,
          )
        );
      } else if (e is TimeoutException) {
        throw _errorService.handleError(
          TimeoutError(
            message: 'Request timed out while fetching correlation data',
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
