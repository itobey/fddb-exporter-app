import 'package:fddb_exporter_app/models/product.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_result.g.dart';

@JsonSerializable()
class DailyResult {
  final DateTime date;
  final List<Product> products;
  final double totalCalories;
  final double totalFat;
  final double totalCarbs;
  final double totalSugar;
  final double totalProtein;
  final double totalFibre;

  DailyResult({
    required this.date,
    required this.products,
    required this.totalCalories,
    required this.totalFat,
    required this.totalCarbs,
    required this.totalSugar,
    required this.totalProtein,
    required this.totalFibre,
  });

  factory DailyResult.fromJson(Map<String, dynamic> json) => _$DailyResultFromJson(json);
  Map<String, dynamic> toJson() => _$DailyResultToJson(this);

  String get formattedDate => DateFormat('yyyy-MM-dd').format(date);
}
