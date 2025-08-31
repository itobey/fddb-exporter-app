// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyResult _$DailyResultFromJson(Map<String, dynamic> json) => DailyResult(
      date: DateTime.parse(json['date'] as String),
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalFat: (json['totalFat'] as num).toDouble(),
      totalCarbs: (json['totalCarbs'] as num).toDouble(),
      totalSugar: (json['totalSugar'] as num).toDouble(),
      totalProtein: (json['totalProtein'] as num).toDouble(),
      totalFibre: (json['totalFibre'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyResultToJson(DailyResult instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'products': instance.products,
      'totalCalories': instance.totalCalories,
      'totalFat': instance.totalFat,
      'totalCarbs': instance.totalCarbs,
      'totalSugar': instance.totalSugar,
      'totalProtein': instance.totalProtein,
      'totalFibre': instance.totalFibre,
    };
