// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      amountEntries: (json['amountEntries'] as num).toInt(),
      firstEntryDate: DateTime.parse(json['firstEntryDate'] as String),
      mostRecentMissingDay: json['mostRecentMissingDay'] == null
          ? null
          : DateTime.parse(json['mostRecentMissingDay'] as String),
      entryPercentage: (json['entryPercentage'] as num).toDouble(),
      uniqueProducts: (json['uniqueProducts'] as num).toInt(),
      averageTotals:
          Averages.fromJson(json['averageTotals'] as Map<String, dynamic>),
      highestCaloriesDay:
          DayStats.fromJson(json['highestCaloriesDay'] as Map<String, dynamic>),
      highestFatDay:
          DayStats.fromJson(json['highestFatDay'] as Map<String, dynamic>),
      highestCarbsDay:
          DayStats.fromJson(json['highestCarbsDay'] as Map<String, dynamic>),
      highestProteinDay:
          DayStats.fromJson(json['highestProteinDay'] as Map<String, dynamic>),
      highestFibreDay:
          DayStats.fromJson(json['highestFibreDay'] as Map<String, dynamic>),
      highestSugarDay:
          DayStats.fromJson(json['highestSugarDay'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'amountEntries': instance.amountEntries,
      'firstEntryDate': instance.firstEntryDate.toIso8601String(),
      'mostRecentMissingDay': instance.mostRecentMissingDay?.toIso8601String(),
      'entryPercentage': instance.entryPercentage,
      'uniqueProducts': instance.uniqueProducts,
      'averageTotals': instance.averageTotals,
      'highestCaloriesDay': instance.highestCaloriesDay,
      'highestFatDay': instance.highestFatDay,
      'highestCarbsDay': instance.highestCarbsDay,
      'highestProteinDay': instance.highestProteinDay,
      'highestFibreDay': instance.highestFibreDay,
      'highestSugarDay': instance.highestSugarDay,
    };

Averages _$AveragesFromJson(Map<String, dynamic> json) => Averages(
      avgTotalCalories: (json['avgTotalCalories'] as num).toDouble(),
      avgTotalFat: (json['avgTotalFat'] as num).toDouble(),
      avgTotalCarbs: (json['avgTotalCarbs'] as num).toDouble(),
      avgTotalSugar: (json['avgTotalSugar'] as num).toDouble(),
      avgTotalProtein: (json['avgTotalProtein'] as num).toDouble(),
      avgTotalFibre: (json['avgTotalFibre'] as num).toDouble(),
    );

Map<String, dynamic> _$AveragesToJson(Averages instance) => <String, dynamic>{
      'avgTotalCalories': instance.avgTotalCalories,
      'avgTotalFat': instance.avgTotalFat,
      'avgTotalCarbs': instance.avgTotalCarbs,
      'avgTotalSugar': instance.avgTotalSugar,
      'avgTotalProtein': instance.avgTotalProtein,
      'avgTotalFibre': instance.avgTotalFibre,
    };

DayStats _$DayStatsFromJson(Map<String, dynamic> json) => DayStats(
      date: DateTime.parse(json['date'] as String),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$DayStatsToJson(DayStats instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'total': instance.total,
    };
