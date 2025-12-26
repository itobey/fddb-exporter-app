import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/app_error.dart';
import '../models/daily_result.dart';
import '../config.dart';
import 'error_service.dart';
import 'interfaces/i_daily_search_service.dart';
import 'interfaces/i_error_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DailySearchService implements IDailySearchService {
  final IErrorService _errorService;
  
  /// Creates a DailySearchService with the given ErrorService
  DailySearchService({required IErrorService errorService}) : _errorService = errorService;
  
  /// Fetch daily nutrition totals and entries for a given date.
  /// Performs a GET on /fddbdata/{yyyy-MM-dd} and decodes UTF-8 before parsing.
  Future<DailyResult> fetchDailyNutrition(DateTime date) async {
    late String endpoint;
    String? url;
    String? uri;
    
    try {
      endpoint = await Config.getEndpoint();
      url = '$endpoint/api/v2/fddbdata';
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      uri = "$url/$formattedDate";
      
      final response = await http.get(Uri.parse(uri))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        try {
          final decodedData = utf8.decode(response.bodyBytes);
          final Map<String, dynamic> responseData = json.decode(decodedData);
          return DailyResult.fromJson(responseData);
        } catch (e, stackTrace) {
          throw _errorService.handleError(
            ParseError(
              message: 'Failed to parse daily nutrition data',
              data: response.body,
              stackTrace: stackTrace,
            )
          );
        }
      } else if (response.statusCode >= 500) {
        throw _errorService.handleError(
          ServerError(
            message: 'Server error occurred while fetching daily nutrition data',
            statusCode: response.statusCode,
            url: uri,
          )
        );
      } else if (response.statusCode == 404) {
        // No data available for this day
        throw _errorService.handleError(
          NoDataError(
            stackTrace: StackTrace.current,
          ),
        );
      } else if (response.statusCode >= 400) {
        throw _errorService.handleError(
          ClientError(
            message: 'Client error occurred while fetching daily nutrition data',
            statusCode: response.statusCode,
            url: uri,
          )
        );
      } else {
        throw _errorService.handleError(
          NetworkError(
            message: 'Unexpected status code: ${response.statusCode}',
            statusCode: response.statusCode,
            url: uri,
          )
        );
      }
    } catch (e, stackTrace) {
      if (e is AppError) {
        rethrow;
      } else if (e is SocketException) {
        throw _errorService.handleError(
          NetworkError(
            message: 'Network connection error while fetching daily nutrition data',
            url: uri,
            stackTrace: stackTrace,
          )
        );
      } else if (e is TimeoutException) {
        throw _errorService.handleError(
          TimeoutError(
            message: 'Request timed out while fetching daily nutrition data',
            url: uri,
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