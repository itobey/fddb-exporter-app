// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppError _$AppErrorFromJson(Map<String, dynamic> json) => AppError(
      message: json['message'] as String,
      code: json['code'] as String?,
      stackTrace:
          const StackTraceConverter().fromJson(json['stackTrace'] as String?),
    );

Map<String, dynamic> _$AppErrorToJson(AppError instance) => <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
    };

NetworkError _$NetworkErrorFromJson(Map<String, dynamic> json) => NetworkError(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      url: json['url'] as String?,
      code: json['code'] as String?,
      stackTrace:
          const StackTraceConverter().fromJson(json['stackTrace'] as String?),
    );

Map<String, dynamic> _$NetworkErrorToJson(NetworkError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
      'statusCode': instance.statusCode,
      'url': instance.url,
    };

ServerError _$ServerErrorFromJson(Map<String, dynamic> json) => ServerError(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      url: json['url'] as String?,
      stackTrace:
          const StackTraceConverter().fromJson(json['stackTrace'] as String?),
    );

Map<String, dynamic> _$ServerErrorToJson(ServerError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
      'statusCode': instance.statusCode,
      'url': instance.url,
    };

ClientError _$ClientErrorFromJson(Map<String, dynamic> json) => ClientError(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      url: json['url'] as String?,
      stackTrace:
          const StackTraceConverter().fromJson(json['stackTrace'] as String?),
    );

Map<String, dynamic> _$ClientErrorToJson(ClientError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
      'statusCode': instance.statusCode,
      'url': instance.url,
    };

TimeoutError _$TimeoutErrorFromJson(Map<String, dynamic> json) => TimeoutError(
      message: json['message'] as String,
      timeoutInSeconds: (json['timeoutInSeconds'] as num?)?.toInt(),
      url: json['url'] as String?,
      stackTrace:
          const StackTraceConverter().fromJson(json['stackTrace'] as String?),
    );

Map<String, dynamic> _$TimeoutErrorToJson(TimeoutError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
      'url': instance.url,
      'timeoutInSeconds': instance.timeoutInSeconds,
    };

ParseError _$ParseErrorFromJson(Map<String, dynamic> json) => ParseError(
      message: json['message'] as String,
      data: json['data'] as String?,
      stackTrace:
          const StackTraceConverter().fromJson(json['stackTrace'] as String?),
    );

Map<String, dynamic> _$ParseErrorToJson(ParseError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
      'data': instance.data,
    };

ValidationError _$ValidationErrorFromJson(Map<String, dynamic> json) =>
    ValidationError(
      message: json['message'] as String,
      fieldErrors: (json['fieldErrors'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      stackTrace:
          const StackTraceConverter().fromJson(json['stackTrace'] as String?),
    );

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
      'fieldErrors': instance.fieldErrors,
    };

UnknownError _$UnknownErrorFromJson(Map<String, dynamic> json) => UnknownError(
      message: json['message'] as String,
      originalError: json['originalError'],
      stackTrace:
          const StackTraceConverter().fromJson(json['stackTrace'] as String?),
    );

Map<String, dynamic> _$UnknownErrorToJson(UnknownError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
      'originalError': instance.originalError,
    };
