import 'package:json_annotation/json_annotation.dart';
import 'stats.dart';

part 'stats_average.g.dart';

@JsonSerializable()
class StatsAverage {
  final String fromDate;
  final String toDate;
  final Averages averages;

  StatsAverage({
    required this.fromDate,
    required this.toDate,
    required this.averages,
  });

  factory StatsAverage.fromJson(Map<String, dynamic> json) => _$StatsAverageFromJson(json);
  Map<String, dynamic> toJson() => _$StatsAverageToJson(this);
}
