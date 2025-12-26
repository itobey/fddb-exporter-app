import 'package:json_annotation/json_annotation.dart';

part 'stats.g.dart';

@JsonSerializable()
class Stats {
  final int amountEntries;
  final DateTime firstEntryDate;
  final DateTime? mostRecentMissingDay;
  final double entryPercentage;
  final int uniqueProducts;
  final Averages averageTotals;
  final DayStats highestCaloriesDay;
  final DayStats highestFatDay;
  final DayStats highestCarbsDay;
  final DayStats highestProteinDay;
  final DayStats highestFibreDay;
  final DayStats highestSugarDay;

  Stats({
    required this.amountEntries,
    required this.firstEntryDate,
    this.mostRecentMissingDay,
    required this.entryPercentage,
    required this.uniqueProducts,
    required this.averageTotals,
    required this.highestCaloriesDay,
    required this.highestFatDay,
    required this.highestCarbsDay,
    required this.highestProteinDay,
    required this.highestFibreDay,
    required this.highestSugarDay,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
  Map<String, dynamic> toJson() => _$StatsToJson(this);
}

@JsonSerializable()
class Averages {
  final double avgTotalCalories;
  final double avgTotalFat;
  final double avgTotalCarbs;
  final double avgTotalSugar;
  final double avgTotalProtein;
  final double avgTotalFibre;

  Averages({
    required this.avgTotalCalories,
    required this.avgTotalFat,
    required this.avgTotalCarbs,
    required this.avgTotalSugar,
    required this.avgTotalProtein,
    required this.avgTotalFibre,
  });

  factory Averages.fromJson(Map<String, dynamic> json) => _$AveragesFromJson(json);
  Map<String, dynamic> toJson() => _$AveragesToJson(this);
}

@JsonSerializable()
class DayStats {
  final DateTime date;
  final double total;

  DayStats({
    required this.date,
    required this.total,
  });

  factory DayStats.fromJson(Map<String, dynamic> json) => _$DayStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DayStatsToJson(this);
}

