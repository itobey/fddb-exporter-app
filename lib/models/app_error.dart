import 'package:json_annotation/json_annotation.dart';

part 'app_error.g.dart';

/// Custom JsonConverter for StackTrace
class StackTraceConverter implements JsonConverter<StackTrace?, String?> {
  const StackTraceConverter();

  @override
  StackTrace? fromJson(String? json) {
    if (json == null) return null;
    return StackTrace.fromString(json);
  }

  @override
  String? toJson(StackTrace? stackTrace) {
    if (stackTrace == null) return null;
    return stackTrace.toString();
  }
}

/// Base class for all application errors
@JsonSerializable()
class AppError implements Exception {
  final String message;
  final String? code;
  
  @StackTraceConverter()
  final StackTrace? stackTrace;

  AppError({
    required this.message,
    this.code,
    this.stackTrace,
  });

  factory AppError.fromJson(Map<String, dynamic> json) => _$AppErrorFromJson(json);
  Map<String, dynamic> toJson() => _$AppErrorToJson(this);

  @override
  String toString() => 'AppError: $message${code != null ? ' (code: $code)' : ''}';
}

/// Network related errors (connectivity, timeouts, etc.)
@JsonSerializable()
class NetworkError extends AppError {
  final int? statusCode;
  final String? url;

  NetworkError({
    required String message,
    this.statusCode,
    this.url,
    String? code,
    @StackTraceConverter() StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code ?? 'NETWORK_ERROR',
          stackTrace: stackTrace,
        );

  factory NetworkError.fromJson(Map<String, dynamic> json) => _$NetworkErrorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$NetworkErrorToJson(this);

  @override
  String toString() => 'NetworkError: $message${statusCode != null ? ' (status: $statusCode)' : ''}${url != null ? ' (url: $url)' : ''}';
}

/// Server errors (5xx status codes)
@JsonSerializable()
class ServerError extends NetworkError {
  ServerError({
    required String message,
    int? statusCode,
    String? url,
    @StackTraceConverter() StackTrace? stackTrace,
  }) : super(
          message: message,
          statusCode: statusCode,
          url: url,
          code: 'SERVER_ERROR',
          stackTrace: stackTrace,
        );

  factory ServerError.fromJson(Map<String, dynamic> json) => _$ServerErrorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ServerErrorToJson(this);
}

/// Client errors (4xx status codes)
@JsonSerializable()
class ClientError extends NetworkError {
  ClientError({
    required String message,
    int? statusCode,
    String? url,
    @StackTraceConverter() StackTrace? stackTrace,
  }) : super(
          message: message,
          statusCode: statusCode,
          url: url,
          code: 'CLIENT_ERROR',
          stackTrace: stackTrace,
        );

  factory ClientError.fromJson(Map<String, dynamic> json) => _$ClientErrorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ClientErrorToJson(this);
}

/// Timeout errors
@JsonSerializable()
class TimeoutError extends NetworkError {
  final int? timeoutInSeconds;

  TimeoutError({
    required String message,
    this.timeoutInSeconds,
    String? url,
    @StackTraceConverter() StackTrace? stackTrace,
  }) : super(
          message: message,
          url: url,
          code: 'TIMEOUT_ERROR',
          stackTrace: stackTrace,
        );

  factory TimeoutError.fromJson(Map<String, dynamic> json) => _$TimeoutErrorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TimeoutErrorToJson(this);

  @override
  String toString() => 'TimeoutError: $message${timeoutInSeconds != null ? ' (timeout: ${timeoutInSeconds}s)' : ''}${url != null ? ' (url: $url)' : ''}';
}

/// Data parsing errors
@JsonSerializable()
class ParseError extends AppError {
  final String? data;

  ParseError({
    required String message,
    this.data,
    @StackTraceConverter() StackTrace? stackTrace,
  }) : super(
          message: message,
          code: 'PARSE_ERROR',
          stackTrace: stackTrace,
        );

  factory ParseError.fromJson(Map<String, dynamic> json) => _$ParseErrorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ParseErrorToJson(this);
}

/// Validation errors
@JsonSerializable()
class ValidationError extends AppError {
  final Map<String, String>? fieldErrors;

  ValidationError({
    required String message,
    this.fieldErrors,
    @StackTraceConverter() StackTrace? stackTrace,
  }) : super(
          message: message,
          code: 'VALIDATION_ERROR',
          stackTrace: stackTrace,
        );

  factory ValidationError.fromJson(Map<String, dynamic> json) => _$ValidationErrorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @override
  String toString() {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      final fields = fieldErrors!.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      return 'ValidationError: $message (fields: $fields)';
    }
    return 'ValidationError: $message';
  }
}

/// Unknown errors
@JsonSerializable()
class UnknownError extends AppError {
  final dynamic originalError;

  UnknownError({
    required String message,
    this.originalError,
    @StackTraceConverter() StackTrace? stackTrace,
  }) : super(
          message: message,
          code: 'UNKNOWN_ERROR',
          stackTrace: stackTrace,
        );

  factory UnknownError.fromJson(Map<String, dynamic> json) => _$UnknownErrorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UnknownErrorToJson(this);
}

/// Specific error indicating that there is no data available for the requested resource/day
/// Not using JsonSerializable to avoid the need for code generation.
class NoDataError extends AppError {
  NoDataError({
    String message = 'There is no data for this day available.',
    @StackTraceConverter() StackTrace? stackTrace,
  }) : super(
          message: message,
          code: 'NO_DATA',
          stackTrace: stackTrace,
        );
}