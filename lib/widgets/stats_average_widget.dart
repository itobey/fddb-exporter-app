import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/stats.dart';
import '../models/stats_average.dart';
import '../service/service_locator.dart';
import '../service/stats_service.dart';
import '../view/sidebar_drawer.dart';
import '../shared/widgets/card_section.dart';

class StatsAverageWidget extends StatefulWidget {
  const StatsAverageWidget({super.key});

  @override
  _StatsAverageWidgetState createState() => _StatsAverageWidgetState();
}

class _StatsAverageWidgetState extends State<StatsAverageWidget> {
  final StatsService _statsService = ServiceLocator().statsService;
  int _selectedIndex = 0;
  DateTime? _fromDate;
  DateTime? _toDate;
  Averages? _totalAverages;
  Averages? _customAverages;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTotalAverages();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _error = null;
    });
  }

  Future<void> _fetchTotalAverages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final stats = await _statsService.getStats();
      setState(() {
        _totalAverages = stats.averageTotals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCustomAverages(DateTime fromDate, DateTime toDate) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final fromDateStr = DateFormat('yyyy-MM-dd').format(fromDate);
      final toDateStr = DateFormat('yyyy-MM-dd').format(toDate);
      final statsAverage = await _statsService.getAverages(fromDateStr, toDateStr);
      setState(() {
        _customAverages = statsAverage.averages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _showDatePicker(bool isFromDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate ? DateTime.now().subtract(const Duration(days: 2)) : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = pickedDate;
        } else {
          _toDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats Average'),
      ),
      drawer: const SidebarDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics),
                    label: 'Total',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.date_range),
                    label: 'Custom',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedIndex == 1)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        readOnly: true,
                        onTap: () => _showDatePicker(true),
                        controller: TextEditingController(
                          text: _fromDate != null ? DateFormat('yyyy-MM-dd').format(_fromDate!) : '',
                        ),
                        decoration: InputDecoration(
                          hintText: 'From Date',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.event),
                            onPressed: () => _showDatePicker(true),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        readOnly: true,
                        onTap: () => _showDatePicker(false),
                        controller: TextEditingController(
                          text: _toDate != null ? DateFormat('yyyy-MM-dd').format(_toDate!) : '',
                        ),
                        decoration: InputDecoration(
                          hintText: 'To Date',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.event),
                            onPressed: () => _showDatePicker(false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_fromDate != null && _toDate != null) {
                              _fetchCustomAverages(_fromDate!, _toDate!);
                            }
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Fetch Data'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Error: $_error',
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  TextButton(
                                    onPressed: () {
                                      if (_selectedIndex == 0) {
                                        _fetchTotalAverages();
                                      } else if (_selectedIndex == 1 && _fromDate != null && _toDate != null) {
                                        _fetchCustomAverages(_fromDate!, _toDate!);
                                      }
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : _buildAveragesDisplay(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAveragesDisplay() {
    final averages = _selectedIndex == 0 ? _totalAverages : _customAverages;
    
    if (averages == null) {
      return const Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text('No data available.'),
        ),
      );
    }

    final cs = Theme.of(context).colorScheme;
    // Build a dynamic title: overall for total, and include the queried dates for custom.
    String title;
    if (_selectedIndex == 0) {
      title = 'Overall averages';
    } else {
      if (_fromDate != null && _toDate != null) {
        final fromStr = DateFormat('yyyy-MM-dd').format(_fromDate!);
        final toStr = DateFormat('yyyy-MM-dd').format(_toDate!);
        title = 'Averages for $fromStr - $toStr';
      } else {
        title = 'Custom period averages';
      }
    }

    return Align(
      alignment: Alignment.topLeft,
      child: CardSection(
        title: title,
        leadingIcon: Icons.insights,
        children: [
          GridView.count(
            key: ValueKey('averages-$_selectedIndex'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: [
              _statBadge(icon: Icons.bolt, label: 'Calories', value: '${averages.avgTotalCalories.toStringAsFixed(2)} kcal', color: cs.primary),
              _statBadge(icon: Icons.fitness_center, label: 'Protein', value: '${averages.avgTotalProtein.toStringAsFixed(2)} g', color: const Color(0xFF10B981)),
              _statBadge(icon: Icons.local_pizza, label: 'Carbs', value: '${averages.avgTotalCarbs.toStringAsFixed(2)} g', color: const Color(0xFF374151)),
              _statBadge(icon: Icons.trending_up, label: 'Fat', value: '${averages.avgTotalFat.toStringAsFixed(2)} g', color: cs.secondary),
              _statBadge(icon: Icons.water_drop, label: 'Sugar', value: '${averages.avgTotalSugar.toStringAsFixed(2)} g', color: cs.primary),
              _statBadge(icon: Icons.grass, label: 'Fiber', value: '${averages.avgTotalFibre.toStringAsFixed(2)} g', color: cs.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBadge({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
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
            textAlign: TextAlign.center,
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
}
