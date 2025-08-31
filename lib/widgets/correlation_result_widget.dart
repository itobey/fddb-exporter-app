import 'package:flutter/material.dart';

import '../models/correlations.dart';
import '../shared/widgets/card_section.dart';

class CorrelationResultTab extends StatelessWidget {
  final CorrelationsData correlationsData;

  const CorrelationResultTab({
    Key? key,
    required this.correlationsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Top metric cards for amounts (same styling as Stats overview cards)
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  context: context,
                  icon: Icons.shopping_bag,
                  label: 'Found Products',
                  value: correlationsData.amountMatchedProducts.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard(
                  context: context,
                  icon: Icons.event,
                  label: 'Found Dates',
                  value: correlationsData.amountMatchedDates.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CardSection(
            title: 'Correlation Analysis Results',
            leadingIcon: Icons.insights,
            children: [
              _correlationRow(context, '2 Days Span', correlationsData.correlations.across2Days),
              _sectionDivider(context),
              _correlationRow(context, '3 Days Span', correlationsData.correlations.across3Days),
              _sectionDivider(context),
              _correlationRow(context, 'Same Day', correlationsData.correlations.sameDay),
              _sectionDivider(context),
              _correlationRow(context, '1 Day Before', correlationsData.correlations.oneDayBefore),
              _sectionDivider(context),
              _correlationRow(context, '2 Days Before', correlationsData.correlations.twoDaysBefore),
            ],
          ),
          const SizedBox(height: 16),
          CardSection(
            title: 'Found Products',
            leadingIcon: Icons.shopping_bag,
            children: [
              _chipWrap(
                context,
                items: correlationsData.matchedProducts,
              ),
            ],
          ),
          const SizedBox(height: 16),
          CardSection(
            title: 'Found Dates',
            leadingIcon: Icons.event,
            children: [
              _chipWrap(
                context,
                items: correlationsData.matchedDates,
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Correlation row: title on left, percentage + matched on right
  Widget _correlationRow(BuildContext context, String title, CorrelationDetail detail) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.timeline, size: 16, color: cs.onSurface.withOpacity(0.7)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${detail.percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              Text(
                'Matched: ${detail.matchedDays}',
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionDivider(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Divider(height: 1, thickness: 1, color: cs.outlineVariant.withOpacity(0.5));
  }

  // Metric card copied from Stats widget styling for top amounts
  Widget _metricCard({required BuildContext context, required IconData icon, required String label, required String value}) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outline),
      ),
      color: cs.surface,
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

  // Outlined chips wrap used for products and dates
  Widget _chipWrap(BuildContext context, {required List<String> items, bool dense = false}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      padding: const EdgeInsets.all(12),
      child: items.isEmpty
          ? Text('No items', style: TextStyle(color: cs.onSurfaceVariant))
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items
                  .map(
                    (e) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: dense ? 8 : 10,
                        vertical: dense ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        e,
                        style: TextStyle(
                          color: cs.onSurface.withOpacity(0.8),
                          fontSize: dense ? 11 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
