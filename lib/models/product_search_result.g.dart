// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearchResult _$ProductSearchResultFromJson(Map<String, dynamic> json) =>
    ProductSearchResult(
      date: DateTime.parse(json['date'] as String),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductSearchResultToJson(
        ProductSearchResult instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'product': instance.product,
    };
