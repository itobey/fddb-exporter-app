// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correlations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CorrelationsData _$CorrelationsDataFromJson(Map<String, dynamic> json) =>
    CorrelationsData(
      correlations:
          Correlations.fromJson(json['correlations'] as Map<String, dynamic>),
      matchedProducts: (json['matchedProducts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      matchedDates: (json['matchedDates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      amountMatchedProducts: (json['amountMatchedProducts'] as num).toInt(),
      amountMatchedDates: (json['amountMatchedDates'] as num).toInt(),
    );

Map<String, dynamic> _$CorrelationsDataToJson(CorrelationsData instance) =>
    <String, dynamic>{
      'correlations': instance.correlations,
      'matchedProducts': instance.matchedProducts,
      'matchedDates': instance.matchedDates,
      'amountMatchedProducts': instance.amountMatchedProducts,
      'amountMatchedDates': instance.amountMatchedDates,
    };

Correlations _$CorrelationsFromJson(Map<String, dynamic> json) => Correlations(
      across3Days: CorrelationDetail.fromJson(
          json['across3Days'] as Map<String, dynamic>),
      across2Days: CorrelationDetail.fromJson(
          json['across2Days'] as Map<String, dynamic>),
      sameDay:
          CorrelationDetail.fromJson(json['sameDay'] as Map<String, dynamic>),
      oneDayBefore: CorrelationDetail.fromJson(
          json['oneDayBefore'] as Map<String, dynamic>),
      twoDaysBefore: CorrelationDetail.fromJson(
          json['twoDaysBefore'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CorrelationsToJson(Correlations instance) =>
    <String, dynamic>{
      'across3Days': instance.across3Days,
      'across2Days': instance.across2Days,
      'sameDay': instance.sameDay,
      'oneDayBefore': instance.oneDayBefore,
      'twoDaysBefore': instance.twoDaysBefore,
    };

CorrelationDetail _$CorrelationDetailFromJson(Map<String, dynamic> json) =>
    CorrelationDetail(
      percentage: (json['percentage'] as num).toDouble(),
      matchedDates: (json['matchedDates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      matchedDays: (json['matchedDays'] as num).toInt(),
    );

Map<String, dynamic> _$CorrelationDetailToJson(CorrelationDetail instance) =>
    <String, dynamic>{
      'percentage': instance.percentage,
      'matchedDates': instance.matchedDates,
      'matchedDays': instance.matchedDays,
    };
