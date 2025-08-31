import 'package:flutter/material.dart';
import 'stat_item.dart';

/// A reusable widget for displaying a row of statistics
class StatRow extends StatelessWidget {
  /// List of statistics to display in the row
  final List<MapEntry<String, String>> stats;
  
  /// Optional background color
  final Color? backgroundColor;
  
  /// Optional vertical padding
  final double verticalPadding;
  
  /// Optional horizontal padding
  final double horizontalPadding;
  
  /// Creates a row of statistics
  const StatRow({
    Key? key,
    required this.stats,
    this.backgroundColor,
    this.verticalPadding = 8.0,
    this.horizontalPadding = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats
            .map((stat) => Expanded(
                  child: Center(
                    child: StatItem(
                      label: stat.key,
                      value: stat.value,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}