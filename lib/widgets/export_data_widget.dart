import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/export_provider.dart';
import '../view/sidebar_drawer.dart';
import '../shared/widgets/card_section.dart';

class ExportDataWidget extends StatefulWidget {
  const ExportDataWidget({super.key});

  @override
  _ExportDataWidgetState createState() => _ExportDataWidgetState();
}

class _ExportDataWidgetState extends State<ExportDataWidget> {
  int _selectedIndex = 0;
  final TextEditingController _daysController = TextEditingController();
  bool _includeToday = false;
  DateTime? _fromDate;
  DateTime? _toDate;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Clear the response data when the tab is changed
      Provider.of<ExportProvider>(context, listen: false).clearData();
    });
  }

  Future<void> _fetchFirstEndpointData(int days, bool includeToday) async {
    FocusScope.of(context).unfocus();
    await Provider.of<ExportProvider>(context, listen: false)
        .fetchDataByDays(days, includeToday);
  }

  Future<void> _fetchSecondEndpointData(DateTime fromDate, DateTime toDate) async {
    FocusScope.of(context).unfocus();
    await Provider.of<ExportProvider>(context, listen: false)
        .fetchDataByDateRange(fromDate, toDate);
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
        title: const Text('Export Data'),
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
                    icon: Icon(Icons.list),
                    label: 'Days Back',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.date_range),
                    label: 'Timeframe',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedIndex == 0)
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
                        controller: _daysController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          final int days = int.tryParse(value) ?? 0;
                          _fetchFirstEndpointData(days, _includeToday);
                        },
                        decoration: InputDecoration(
                          hintText: 'Number of days',
                          prefixIcon: const Icon(Icons.numbers),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: _includeToday,
                            onChanged: (bool? value) {
                              setState(() {
                                _includeToday = value ?? false;
                              });
                            },
                          ),
                          const Text('Include today'),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {
                              final int days = int.tryParse(_daysController.text) ?? 0;
                              _fetchFirstEndpointData(days, _includeToday);
                            },
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Fetch Data'),
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
                    ],
                  ),
                )
              else if (_selectedIndex == 1)
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
                              _fetchSecondEndpointData(_fromDate!, _toDate!);
                            }
                          },
                          icon: const Icon(Icons.download),
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
                  child: Consumer<ExportProvider>(
                    builder: (context, exportProvider, child) {
                      if (exportProvider.isLoading) {
                        return const Center(key: ValueKey('loading'), child: CircularProgressIndicator());
                      }
                      
                      if (exportProvider.error != null) {
                        return Column(
                          key: const ValueKey('error'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              exportProvider.userFriendlyErrorMessage ?? 'An error occurred',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => exportProvider.showErrorDialog(context),
                              child: const Text('Show Details'),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                if (_selectedIndex == 0) {
                                  final int days = int.tryParse(_daysController.text) ?? 0;
                                  _fetchFirstEndpointData(days, _includeToday);
                                } else if (_selectedIndex == 1 && _fromDate != null && _toDate != null) {
                                  _fetchSecondEndpointData(_fromDate!, _toDate!);
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        );
                      }
                      
                      final responseData = exportProvider.responseData;
                      if (responseData == null) {
                        return const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('No data fetched yet.'),
                          ),
                        );
                      }
                      
                      final success = (responseData['successfulDays'] as List<dynamic>).cast<String>();
                      final failed = (responseData['unsuccessfulDays'] as List<dynamic>).cast<String>();
                      
                      return ListView(
                        key: const ValueKey('results'),
                        children: [
                          // Header with badge for counts
                          Row(
                            children: [
                              const Text(
                                'Results',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                  border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${success.length + failed.length} days',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Successful Days - styled like Found Dates in Correlation widget
                          CardSection(
                            title: 'Successful Days',
                            leadingIcon: Icons.check_circle,
                            children: [
                              _chipWrap(context, items: success, dense: true),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Unsuccessful Days - same chip styling
                          CardSection(
                            title: 'Unsuccessful Days',
                            leadingIcon: Icons.cancel,
                            children: [
                              _chipWrap(context, items: failed, dense: true),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Outlined chips wrap styled same as in CorrelationResultTab for Found Dates
  Widget _chipWrap(BuildContext context, {required List<String> items, bool dense = false}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
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