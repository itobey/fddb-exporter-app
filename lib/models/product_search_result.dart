import 'package:fddb_exporter_app/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_search_result.g.dart';

@JsonSerializable()
class ProductSearchResult {
  final DateTime date;
  final Product product;

  ProductSearchResult({
    required this.date,
    required this.product,
  });

  factory ProductSearchResult.fromJson(Map<String, dynamic> json) => _$ProductSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSearchResultToJson(this);
}
