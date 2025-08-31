import 'package:flutter/material.dart';

/// A reusable widget for displaying a statistic item with a label and value
class StatItem extends StatelessWidget {
  /// The label for the statistic
  final String label;
  
  /// The value of the statistic
  final String value;
  
  /// Optional text color for the label
  final Color? labelColor;
  
  /// Optional text color for the value
  final Color? valueColor;
  
  /// Optional text style for the label
  final TextStyle? labelStyle;
  
  /// Optional text style for the value
  final TextStyle? valueStyle;
  
  /// Optional vertical padding
  final double verticalPadding;
  
  /// Creates a statistic item with a label and value
  const StatItem({
    Key? key,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
    this.verticalPadding = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveLabelColor = labelColor ?? colorScheme.secondary;
    final effectiveValueColor = valueColor ?? colorScheme.secondary;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: labelStyle ?? TextStyle(color: effectiveLabelColor),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: valueStyle ?? TextStyle(
              color: effectiveValueColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}