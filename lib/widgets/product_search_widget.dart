import 'package:fddb_exporter_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/app_error.dart';
import '../models/product_search_result.dart';
import '../routes/route_generator.dart';
import '../routes/route_names.dart';
import '../service/error_service.dart';
import '../service/product_service.dart';
import '../service/service_locator.dart';
import '../utils/url_launcher.dart';
import '../view/sidebar_drawer.dart';

class ProductSearch extends StatefulWidget {
  final String? initialQuery;

  const ProductSearch({super.key, this.initialQuery});

  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  final TextEditingController _nameController = TextEditingController();
  List<ProductSearchResult>? _productData;
  late ProductService _productService;
  late ErrorService _errorService;
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  bool _isLoading = false;
  AppError? _error;

  @override
  void initState() {
    super.initState();
    _productService = ServiceLocator().productService;
    _errorService = ServiceLocator().errorService;
    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      _nameController.text = widget.initialQuery!;
      // Delay initial search until after first frame to avoid accessing inherited widgets too early
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _searchProduct(widget.initialQuery!);
        }
      });
    }
  }

  Future<void> _searchProduct(String name) async {
    final query = name.trim();
    if (query.isEmpty) {
      setState(() {
        _error = ValidationError(message: 'Please enter a product name.');
        _productData = null;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      FocusScope.of(context).unfocus();
      final results = await _productService.fetchProducts(query);
      results.sort((a, b) => b.date.compareTo(a.date));
      setState(() {
        _productData = results;
        _isLoading = false;
      });
    } catch (e, stack) {
      final appError = (e is AppError) ? e : _errorService.handleError(e, stack);
      setState(() {
        _error = appError;
        _productData = null;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorService.getUserFriendlyMessage(appError)), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
      ),
      drawer: const SidebarDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Card Container
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // TextField with leading icon
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'product name',
                          prefixIcon: const Icon(Icons.search),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                          ),
                        ),
                        onSubmitted: _searchProduct,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Search Button
                    ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () {
                        final name = _nameController.text;
                        _searchProduct(name);
                      },
                      icon: const Icon(Icons.search, size: 18),
                      label: _isLoading
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Search'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Results header / badge and content with animation
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _isLoading
                      ? const Center(key: ValueKey('loading'), child: CircularProgressIndicator())
                      : _error != null
                      ? Align(
                    key: const ValueKey('error'),
                    alignment: Alignment.topLeft,
                    child: Text(
                      _errorService.getUserFriendlyMessage(_error!),
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                      : _productData == null
                      ? const Align(
                    key: ValueKey('no-data'),
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('No data fetched yet.'),
                    ),
                  )
                      : Column(
                    key: const ValueKey('results'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Search Results',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_productData!.length} items found',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_productData!.isEmpty)
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Theme.of(context).colorScheme.outline),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No items found for "${_nameController.text}". Try a different search term.',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: _productData!.length,
                            itemBuilder: (context, index) {
                              final productResult = _productData![index];
                              final product = productResult.product;
                              return TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, (1 - value) * 12),
                                      child: child,
                                    ),
                                  );
                                },
                                child: ProductCard(
                                  name: product.name,
                                  amount: product.amount,
                                  date: productResult.date,
                                  calories: product.calories.toStringAsFixed(1),
                                  fat: '${product.fat}g',
                                  carbs: '${product.carbs}g',
                                  protein: '${product.protein}g',
                                  onTap: () => UrlLauncher.launchProductUrl(product.link),
                                  onDateTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.dailySearch,
                                      arguments: DailySearchArguments(initialDate: productResult.date),
                                    );
                                  },
                                  compact: true,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}