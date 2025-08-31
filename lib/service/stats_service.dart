import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/app_error.dart';
import '../models/stats.dart';
import 'error_service.dart';
import 'interfaces/i_error_service.dart';
import 'interfaces/i_stats_service.dart';

class StatsService implements IStatsService {
  final IErrorService _errorService;
  
  /// Creates a StatsService with the given ErrorService
  StatsService({required IErrorService errorService}) : _errorService = errorService;
  
  /// Get aggregated statistics from the backend.
  /// Maps the JSON payload to a Stats model with error handling.
  Future<Stats> getStats() async {
    late String endpoint;
    String? url;
    
    try {
      endpoint = await Config.getEndpoint();
      url = '$endpoint/api/v1/fddbdata/stats';
      
      final response = await http.get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        try {
          return Stats.fromJson(json.decode(response.body));
        } catch (e, stackTrace) {
          throw _errorService.handleError(
            ParseError(
              message: 'Failed to parse stats data',
              data: response.body,
              stackTrace: stackTrace,
            )
          );
        }
      } else if (response.statusCode >= 500) {
        throw _errorService.handleError(
          ServerError(
            message: 'Server error occurred while fetching stats',
            statusCode: response.statusCode,
            url: url,
          )
        );
      } else if (response.statusCode >= 400) {
        throw _errorService.handleError(
          ClientError(
            message: 'Client error occurred while fetching stats',
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
            message: 'Network connection error while fetching stats',
            url: url,
            stackTrace: stackTrace,
          )
        );
      } else if (e is TimeoutException) {
        throw _errorService.handleError(
          TimeoutError(
            message: 'Request timed out while fetching stats',
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
