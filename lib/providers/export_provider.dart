import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/app_error.dart';
import '../service/di/service_locator.dart';
import '../service/interfaces/i_error_service.dart';
import '../service/interfaces/i_export_service.dart';

class ExportProvider extends ChangeNotifier {
  final IExportService _exportService;
  final IErrorService _errorService;
  
  ExportProvider() : 
    _errorService = getIt<IErrorService>(),
    _exportService = getIt<IExportService>();
  
  Map<String, dynamic>? _responseData;
  bool _isLoading = false;
  AppError? _error;

  // Getters
  Map<String, dynamic>? get responseData => _responseData;
  bool get isLoading => _isLoading;
  AppError? get error => _error;
  String? get errorMessage => _error?.message;
  
  // Get user-friendly error message
  String? get userFriendlyErrorMessage => 
      _error != null ? _errorService.getUserFriendlyMessage(_error!) : null;

  // Fetch data using days back method
  Future<void> fetchDataByDays(int days, bool includeToday) async {
    try {
      _setLoading(true);
      _clearError();
      _responseData = await _exportService.fetchDataFromFirstEndpoint(days, includeToday);
      _setLoading(false);
    } catch (e) {
      if (e is AppError) {
        _setAppError(e);
      } else {
        _setAppError(_errorService.handleError(e));
      }
    }
  }

  // Fetch data using date range method
  Future<void> fetchDataByDateRange(DateTime fromDate, DateTime toDate) async {
    try {
      _setLoading(true);
      _clearError();
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      var fromFormatted = dateFormat.format(fromDate);
      var toFormatted = dateFormat.format(toDate);
      _responseData = await _exportService.fetchDataFromSecondEndpoint(fromFormatted, toFormatted);
      _setLoading(false);
    } catch (e) {
      if (e is AppError) {
        _setAppError(e);
      } else {
        _setAppError(_errorService.handleError(e));
      }
    }
  }

  // Clear response data
  void clearData() {
    _responseData = null;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setAppError(AppError error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Show error dialog
  Future<void> showErrorDialog(BuildContext context) async {
    if (_error != null) {
      await _errorService.showErrorDialog(context, _error!);
    }
  }
  
  // Show error snackbar
  void showErrorSnackBar(BuildContext context) {
    if (_error != null) {
      _errorService.showErrorSnackBar(context, _error!);
    }
  }
}