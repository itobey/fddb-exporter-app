import 'package:flutter/material.dart';
import '../models/stats.dart';
import '../service/service_locator.dart';
import '../service/stats_service.dart';
import '../shared/widgets/card_section.dart';
import '../view/sidebar_drawer.dart';
import 'package:intl/intl.dart';
import '../routes/route_generator.dart';
import '../routes/route_names.dart';

class StatsDisplayWidget extends StatefulWidget {
  const StatsDisplayWidget({Key? key}) : super(key: key);

  @override
  _StatsDisplayWidgetState createState() => _StatsDisplayWidgetState();
}

class _StatsDisplayWidgetState extends State<StatsDisplayWidget> {
  final StatsService _statsService = ServiceLocator().statsService;
  Stats? _stats;
  String? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _stats = await _statsService.getStats();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      drawer: const SidebarDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                          'Error: $_error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : _stats == null
                        ? const Align(
                            key: ValueKey('no-data'),
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text('No statistics available.'),
                            ),
                          )
                        : Column(
                            key: const ValueKey('content'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Expanded(child: _buildStatsData()),
                            ],
                          ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsData() {
    return RefreshIndicator(
      onRefresh: _fetchStats,
      child: ListView(
        children: [
          _buildGeneralStats(),
          const SizedBox(height: 16),
          _buildAverages('Overall averages', _stats!.averageTotals, leadingIcon: Icons.insights),
          const SizedBox(height: 16),
          _buildAverages('Last 7 Days Average', _stats!.last7DaysAverage, leadingIcon: Icons.calendar_today),
          const SizedBox(height: 16),
          _buildAverages('Last 30 Days Average', _stats!.last30DaysAverage, leadingIcon: Icons.calendar_month),
          const SizedBox(height: 16),
          _buildRecordHighs(),
        ],
      ),
    );
  }

  // Using the reusable CardSection widget instead of _buildCardSection

  Widget _buildGeneralStats() {
    // Overview cards: Total Entries and Entry Rate
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            icon: Icons.calendar_today,
            label: 'Total Entries',
            value: _stats!.amountEntries.toString(),
            color: cs.surface,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricCard(
            icon: Icons.track_changes,
            label: 'Entry Rate',
            value: '${_stats!.entryPercentage.toStringAsFixed(2)}%',
            color: cs.surface,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outline),
      ),
      color: color ?? cs.surface,
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAverages(String title, Averages a, {IconData? leadingIcon}) {
    final cs = Theme.of(context).colorScheme;
    return CardSection(
      title: title,
      leadingIcon: leadingIcon,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.8,
          children: [
            _statBadge(icon: Icons.bolt, label: 'Calories', value: '${a.avgTotalCalories.toStringAsFixed(2)} kcal', color: cs.primary),
            _statBadge(icon: Icons.fitness_center, label: 'Protein', value: '${a.avgTotalProtein.toStringAsFixed(2)} g', color: const Color(0xFF10B981)),
            _statBadge(icon: Icons.local_pizza, label: 'Carbs', value: '${a.avgTotalCarbs.toStringAsFixed(2)} g', color: const Color(0xFF374151)),
            _statBadge(icon: Icons.trending_up, label: 'Fat', value: '${a.avgTotalFat.toStringAsFixed(2)} g', color: cs.secondary),
            _statBadge(icon: Icons.water_drop, label: 'Sugar', value: '${a.avgTotalSugar.toStringAsFixed(2)} g', color: cs.primary),
            _statBadge(icon: Icons.grass, label: 'Fiber', value: '${a.avgTotalFibre.toStringAsFixed(2)} g', color: cs.primary),
          ],
        ),
      ],
    );
  }

  Widget _labelValueRow(String label, String value) {
    // Fallback text row (kept in case we need a simple row somewhere)
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: cs.primary)),
      ],
    );
  }

  // Badge-style tile matching ProductCard macro tiles
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

  // Compact value badge for Record Highs (value only)
  Widget _valueBadge(String text, {Color? color}) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.primary;
    return Container(
      decoration: BoxDecoration(
        color: c.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: c),
      ),
    );
  }

  Widget _buildRecordHighs() {
    final cs = Theme.of(context).colorScheme;
    return CardSection(
      title: 'Record Highs',
      leadingIcon: Icons.emoji_events,
      children: [
        _recordHighItem('Highest Calories', _stats!.highestCaloriesDay, 'kcal', divider: true),
        _recordHighItem('Highest Protein', _stats!.highestProteinDay, 'g', divider: true),
        _recordHighItem('Highest Carbs', _stats!.highestCarbsDay, 'g', divider: true),
        _recordHighItem('Highest Fat', _stats!.highestFatDay, 'g', divider: true),
        _recordHighItem('Highest Fiber', _stats!.highestFibreDay, 'g', divider: true),
        _recordHighItem('Highest Sugar', _stats!.highestSugarDay, 'g'),
      ],
    );
  }

  Widget _recordHighItem(String label, DayStats data, String unit, {bool divider = false}) {
    final cs = Theme.of(context).colorScheme;
    final valueText = '${data.total.toStringAsFixed(label == 'Highest Calories' ? 0 : 1)} $unit';
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // Navigate to the Daily Search screen for the selected record day
            Navigator.pushNamed(
              context,
              RouteNames.dailySearch,
              arguments: DailySearchArguments(initialDate: data.date),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
                    const SizedBox(height: 2),
                    Text(DateFormat('dd.MM.yyyy').format(data.date), style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                  ],
                ),
                _valueBadge(valueText, color: cs.primary),
              ],
            ),
          ),
        ),
        if (divider) Divider(height: 1, color: cs.outlineVariant.withOpacity(0.5)),
      ],
    );
  }

  // These methods have been replaced by the StatRow and StatItem widgets
}
