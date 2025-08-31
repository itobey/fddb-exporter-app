import '../../models/product_search_result.dart';

/// Interface for the ProductService
abstract class IProductService {
  /// Fetches products by name
  /// 
  /// [name] The name of the product to search for
  /// 
  /// Returns a list of ProductSearchResult objects matching the search criteria
  Future<List<ProductSearchResult>> fetchProducts(String name);
}