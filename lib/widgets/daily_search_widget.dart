import 'package:fddb_exporter_app/models/daily_result.dart';
import 'package:fddb_exporter_app/service/daily_search_service.dart';
import 'package:fddb_exporter_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../service/service_locator.dart';
import '../utils/url_launcher.dart';
import '../view/sidebar_drawer.dart';
import '../models/app_error.dart';

class DailySearchWidget extends StatefulWidget {
  final DateTime? initialDate;

  const DailySearchWidget({super.key, this.initialDate});

  @override
  _DailySearchWidgetState createState() => _DailySearchWidgetState();
}

class _DailySearchWidgetState extends State<DailySearchWidget> {
  final DailySearchService _dailySearchService = ServiceLocator().dailySearchService;
  DailyResult? _responseData;
  DateTime? _selectedDate;
  String? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      // Delay fetching until after the first frame so context-dependent calls are safe
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fetchNutritionData();
        }
      });
    }
  }

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _fetchNutritionData();
    }
  }

  Future<void> _fetchNutritionData() async {
    if (_selectedDate == null) {
      setState(() {
        _error = 'Please select a date first.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      FocusScope.of(context).unfocus();
      _responseData = await _dailySearchService.fetchDailyNutrition(_selectedDate!);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        if (e is AppError) {
          _error = ServiceLocator().errorService.getUserFriendlyMessage(e);
        } else {
          _error = 'An error occurred: $e';
        }
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Nutrition'),
      ),
      drawer: const SidebarDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container
              (
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
                padding: const EdgeInsets.all(12),
                child: TextField(
                  readOnly: true,
                  onTap: _showDatePicker,
                  controller: TextEditingController(
                    text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Select Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.event),
                      onPressed: _showDatePicker,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                )
              else if (_responseData == null)
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('Select a date to fetch nutrition data.'),
                  ),
                )
              else
                Expanded(child: _buildNutritionData()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionData() {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      children: [
        _buildTotalNutrition(),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              'Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.1),
                border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_responseData?.products.length ?? 0} items',
                style: TextStyle(color: colorScheme.onSurface, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._buildProductList(),
      ],
    );
  }

  Widget _macroTile(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: cs.onSurface.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalNutrition() {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline),
      ),
      color: colorScheme.surface,
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Totals',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 12),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.8,
              ),
              children: [
                _macroTile(context, icon: Icons.bolt, label: 'Calories', value: '${_responseData!.totalCalories.round()}', color: colorScheme.primary),
                _macroTile(context, icon: Icons.trending_up, label: 'Fat', value: _responseData!.totalFat.toStringAsFixed(1) + ' g', color: colorScheme.secondary),
                _macroTile(context, icon: Icons.local_pizza, label: 'Carbs', value: _responseData!.totalCarbs.toStringAsFixed(1) + ' g', color: const Color(0xFF374151)),
                _macroTile(context, icon: Icons.fitness_center, label: 'Protein', value: _responseData!.totalProtein.toStringAsFixed(1) + ' g', color: const Color(0xFF10B981)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProductList() {
    return _responseData!.products.map((product) => _buildProductItem(product)).toList();
  }

  Widget _buildProductItem(Product product) {
    return InkWell(
      onTap: () => UrlLauncher.launchProductUrl(product.link),
      child: ProductCard(
        name: product.name,
        amount: product.amount,
        date: _selectedDate!,
        calories: product.calories.toStringAsFixed(1),
        fat: '${product.fat.toStringAsFixed(1)} g',
        carbs: '${product.carbs.toStringAsFixed(1)} g',
        protein: '${product.protein.toStringAsFixed(1)} g',
        compact: true,
      ),
    );
  }
}