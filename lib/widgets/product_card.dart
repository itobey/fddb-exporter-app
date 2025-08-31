import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime date;
  final String calories;
  final String fat;
  final String carbs;
  final String protein;
  final VoidCallback? onTap;
  final VoidCallback? onDateTap;
  final bool compact;

  const ProductCard({
    Key? key,
    required this.name,
    required this.amount,
    required this.date,
    required this.calories,
    required this.fat,
    required this.carbs,
    required this.protein,
    this.onTap,
    this.onDateTap,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('dd.MM.yyyy');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cs.outline),
        ),
        color: cs.surface,
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          amount,
                          style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onDateTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dateFormat.format(date),
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Macro display: chips in compact mode, grid otherwise
              if (compact)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _macroChip(
                      context,
                      icon: Icons.bolt,
                      label: 'Cal',
                      value: '${calories.split('.')[0]}',
                      color: cs.primary,
                    ),
                    _macroChip(
                      context,
                      icon: Icons.trending_up,
                      label: 'Fat',
                      value: fat,
                      color: cs.secondary,
                    ),
                    _macroChip(
                      context,
                      icon: Icons.local_pizza,
                      label: 'Carb',
                      value: carbs,
                      color: const Color(0xFF374151),
                    ),
                    _macroChip(
                      context,
                      icon: Icons.fitness_center,
                      label: 'Prot',
                      value: protein,
                      color: const Color(0xFF10B981),
                    ),
                  ],
                )
              else
                GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.8,
                  ),
                  children: [
                    _macroTile(
                      context,
                      icon: Icons.bolt,
                      label: 'Calories',
                      value: '${calories.split('.')[0]}',
                      color: cs.primary,
                    ),
                    _macroTile(
                      context,
                      icon: Icons.trending_up,
                      label: 'Fat',
                      value: fat,
                      color: cs.secondary,
                    ),
                    _macroTile(
                      context,
                      icon: Icons.local_pizza, // using apple-like metaphor alternative
                      label: 'Carbs',
                      value: carbs,
                      color: const Color(0xFF374151),
                    ),
                    _macroTile(
                      context,
                      icon: Icons.fitness_center,
                      label: 'Protein',
                      value: protein,
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroTile(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    final cs = Theme.of(context).colorScheme;
    final double iconSize = 14;
    final double labelFont = 11;
    final double valueFont = 13;
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: iconSize, color: cs.onSurface.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: labelFont, color: cs.onSurface.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
              fontSize: valueFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroChip(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    final cs = Theme.of(context).colorScheme;
    final double iconSize = 12;
    final TextStyle textStyle = TextStyle(
      fontSize: 11,
      color: cs.onSurface.withOpacity(0.8),
    );
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: cs.onSurface.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text('$label:', style: textStyle.copyWith(color: cs.onSurface.withOpacity(0.6))),
          const SizedBox(width: 4),
          Text(
            value,
            style: textStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}