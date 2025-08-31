// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportStatus _$ExportStatusFromJson(Map<String, dynamic> json) => ExportStatus(
      successfulDays: (json['successfulDays'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      unsuccessfulDays: (json['unsuccessfulDays'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ExportStatusToJson(ExportStatus instance) =>
    <String, dynamic>{
      'successfulDays': instance.successfulDays,
      'unsuccessfulDays': instance.unsuccessfulDays,
    };
