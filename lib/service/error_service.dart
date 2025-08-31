import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/app_error.dart';
import 'interfaces/i_error_service.dart';

class ErrorService implements IErrorService {
  static final ErrorService _instance = ErrorService._internal();
  
  factory ErrorService() => _instance;
  
  ErrorService._internal();

  // Stream controller for global error events
  final StreamController<AppError> _errorStreamController = StreamController<AppError>.broadcast();
  
  // Stream of error events that widgets can listen to
  Stream<AppError> get onError => _errorStreamController.stream;

  // Method to handle and categorize errors
  AppError handleError(dynamic error, [StackTrace? stackTrace]) {
    final AppError appError = _categorizeError(error, stackTrace);
    
    // Log the error
    _logError(appError);
    
    // Add to stream for listeners
    _errorStreamController.add(appError);
    
    return appError;
  }

  // Categorize errors into specific types
  AppError _categorizeError(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppError) {
      return error;
    }
    
    // Handle network errors
    if (error is SocketException) {
      return NetworkError(
        message: 'Network connection error: ${error.message}',
        stackTrace: stackTrace,
      );
    }
    
    if (error is TimeoutException) {
      return TimeoutError(
        message: 'Request timed out',
        stackTrace: stackTrace,
      );
    }
    
    if (error is http.ClientException) {
      return NetworkError(
        message: 'HTTP client error: ${error.message}',
        stackTrace: stackTrace,
      );
    }
    
    if (error is FormatException) {
      return ParseError(
        message: 'Data format error: ${error.message}',
        stackTrace: stackTrace,
      );
    }
    
    // Default to unknown error
    return UnknownError(
      message: error?.toString() ?? 'An unknown error occurred',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  // Log errors appropriately
  void _logError(AppError error) {
    // In production, you might want to send this to a logging service
    if (kDebugMode) {
      print('ERROR: ${error.toString()}');
      if (error.stackTrace != null) {
        print('STACK TRACE: ${error.stackTrace}');
      }
    }
  }

  // Helper method to create a user-friendly error message
  String getUserFriendlyMessage(AppError error) {
    switch (error.runtimeType) {
      case NetworkError:
        return 'Unable to connect to the server. Please check your internet connection.';
      case TimeoutError:
        return 'The request took too long to complete. Please try again.';
      case ServerError:
        return 'There was a problem with the server. Please try again later.';
      case NoDataError:
        return (error as NoDataError).message;
      case ClientError:
        final clientError = error as ClientError;
        if (clientError.statusCode == 401 || clientError.statusCode == 403) {
          return 'You are not authorized to perform this action.';
        }
        if (clientError.statusCode == 404) {
          return 'The requested resource was not found.';
        }
        return 'There was a problem with your request. Please try again.';
      case ValidationError:
        final ve = error as ValidationError;
        if (ve.message.trim().isNotEmpty) {
          return ve.message;
        }
        return 'Please check your input and try again.';
      case ParseError:
        return 'There was a problem processing the data. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  // Show error dialog
  Future<void> showErrorDialog(BuildContext context, AppError error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(getUserFriendlyMessage(error)),
                if (kDebugMode) const SizedBox(height: 16),
                if (kDebugMode) Text(
                  error.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show a snackbar with error message
  void showErrorSnackBar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getUserFriendlyMessage(error)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Dispose resources
  void dispose() {
    _errorStreamController.close();
  }
}