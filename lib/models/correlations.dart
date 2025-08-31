import 'package:json_annotation/json_annotation.dart';

part 'correlations.g.dart';

@JsonSerializable()
class CorrelationsData {
  final Correlations correlations;
  final List<String> matchedProducts;
  final List<String> matchedDates;
  final int amountMatchedProducts;
  final int amountMatchedDates;

  CorrelationsData({
    required this.correlations,
    required this.matchedProducts,
    required this.matchedDates,
    required this.amountMatchedProducts,
    required this.amountMatchedDates,
  });

  factory CorrelationsData.fromJson(Map<String, dynamic> json) => _$CorrelationsDataFromJson(json);
  Map<String, dynamic> toJson() => _$CorrelationsDataToJson(this);
}

@JsonSerializable()
class Correlations {
  final CorrelationDetail across3Days;
  final CorrelationDetail across2Days;
  final CorrelationDetail sameDay;
  final CorrelationDetail oneDayBefore;
  final CorrelationDetail twoDaysBefore;

  Correlations({
    required this.across3Days,
    required this.across2Days,
    required this.sameDay,
    required this.oneDayBefore,
    required this.twoDaysBefore,
  });

  factory Correlations.fromJson(Map<String, dynamic> json) => _$CorrelationsFromJson(json);
  Map<String, dynamic> toJson() => _$CorrelationsToJson(this);
}

@JsonSerializable()
class CorrelationDetail {
  final double percentage;
  final List<String> matchedDates;
  final int matchedDays;

  CorrelationDetail({
    required this.percentage,
    required this.matchedDates,
    required this.matchedDays,
  });

  factory CorrelationDetail.fromJson(Map<String, dynamic> json) => _$CorrelationDetailFromJson(json);
  Map<String, dynamic> toJson() => _$CorrelationDetailToJson(this);
}
