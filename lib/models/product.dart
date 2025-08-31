import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String name;
  final String amount;
  final double calories;
  final double fat;
  final double carbs;
  final double protein;
  final String link;

  Product({
    required this.name,
    required this.amount,
    required this.calories,
    required this.fat,
    required this.carbs,
    required this.protein,
    required this.link,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}