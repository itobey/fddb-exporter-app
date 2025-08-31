import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/app_error.dart';

/// Interface for the ErrorService
abstract class IErrorService {
  /// Stream of error events that widgets can listen to
  Stream<AppError> get onError;

  /// Method to handle and categorize errors
  AppError handleError(dynamic error, [StackTrace? stackTrace]);

  /// Helper method to create a user-friendly error message
  String getUserFriendlyMessage(AppError error);

  /// Show error dialog
  Future<void> showErrorDialog(BuildContext context, AppError error);

  /// Show a snackbar with error message
  void showErrorSnackBar(BuildContext context, AppError error);

  /// Dispose resources
  void dispose();
}