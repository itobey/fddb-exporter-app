import 'package:flutter/material.dart';

/// A reusable card section widget with a title and content
class CardSection extends StatelessWidget {
  /// The title of the card section
  final String title;
  
  /// Optional leading icon shown before the title
  final IconData? leadingIcon;

  /// The children widgets to display in the card
  final List<Widget> children;
  
  /// Optional custom title style
  final TextStyle? titleStyle;
  
  /// Optional custom card color
  final Color? cardColor;
  
  /// Optional custom title color
  final Color? titleColor;
  
  /// Optional border radius
  final double borderRadius;
  
  /// Optional elevation
  final double elevation;

  /// Creates a card section with a title and content
  const CardSection({
    Key? key,
    required this.title,
    required this.children,
    this.leadingIcon,
    this.titleStyle,
    this.cardColor,
    this.titleColor,
    this.borderRadius = 12.0,
    this.elevation = 1.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveCardColor = cardColor ?? cs.surface;
    final effectiveTitleColor = titleColor ?? cs.onSurface;
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: cs.outline),
      ),
      color: effectiveCardColor,
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 18, color: effectiveTitleColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: titleStyle ?? TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: effectiveTitleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}