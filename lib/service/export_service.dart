import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fddb_exporter_app/config.dart';
import 'package:fddb_exporter_app/models/app_error.dart';
import 'package:fddb_exporter_app/service/error_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_error_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_export_service.dart';
import 'package:http/http.dart' as http;

class ExportService implements IExportService {
  final IErrorService _errorService;
  
  /// Creates an ExportService with the given ErrorService
  ExportService({required IErrorService errorService}) : _errorService = errorService;

  /// Fetch exported data using days-back mode.
  /// Builds a GET URL with days and includeToday and applies robust error mapping.
  Future<Map<String, dynamic>> fetchDataFromFirstEndpoint(int days, bool includeToday) async {
    late String endpoint;
    String? url;
    
    try {
      endpoint = await Config.getEndpoint();
      url = '$endpoint/api/v2/fddbdata/export?days=$days&includeToday=$includeToday';
      
      final response = await http.get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return responseData;
        } catch (e, stackTrace) {
          throw _errorService.handleError(
            ParseError(
              message: 'Failed to parse response data',
              data: response.body,
              stackTrace: stackTrace,
            )
          );
        }
      } else if (response.statusCode >= 500) {
        throw _errorService.handleError(
          ServerError(
            message: 'Server error occurred',
            statusCode: response.statusCode,
            url: url,
          )
        );
      } else if (response.statusCode >= 400) {
        throw _errorService.handleError(
          ClientError(
            message: 'Client error occurred',
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
            message: 'Network connection error',
            url: url,
            stackTrace: stackTrace,
          )
        );
      } else if (e is TimeoutException) {
        throw _errorService.handleError(
          TimeoutError(
            message: 'Request timed out',
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

  /// Fetch exported data for a specific date range.
  /// Sends a POST with fromDate/toDate in yyyy-MM-dd format and handles parsing.
  Future<Map<String, dynamic>> fetchDataFromSecondEndpoint(String fromDate, String toDate) async {
    late String endpoint;
    String? url;
    
    try {
      endpoint = await Config.getEndpoint();
      url = '$endpoint/api/v2/fddbdata';
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'fromDate': fromDate, 'toDate': toDate}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return responseData;
        } catch (e, stackTrace) {
          throw _errorService.handleError(
            ParseError(
              message: 'Failed to parse response data',
              data: response.body,
              stackTrace: stackTrace,
            )
          );
        }
      } else if (response.statusCode >= 500) {
        throw _errorService.handleError(
          ServerError(
            message: 'Server error occurred',
            statusCode: response.statusCode,
            url: url,
          )
        );
      } else if (response.statusCode >= 400) {
        throw _errorService.handleError(
          ClientError(
            message: 'Client error occurred',
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
            message: 'Network connection error',
            url: url,
            stackTrace: stackTrace,
          )
        );
      } else if (e is TimeoutException) {
        throw _errorService.handleError(
          TimeoutError(
            message: 'Request timed out',
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