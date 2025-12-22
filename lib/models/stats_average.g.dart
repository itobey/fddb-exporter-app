// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_average.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsAverage _$StatsAverageFromJson(Map<String, dynamic> json) => StatsAverage(
      fromDate: json['fromDate'] as String,
      toDate: json['toDate'] as String,
      averages: Averages.fromJson(json['averages'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatsAverageToJson(StatsAverage instance) =>
    <String, dynamic>{
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'averages': instance.averages,
    };
