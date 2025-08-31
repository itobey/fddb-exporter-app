import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fddb_exporter_app/config.dart';

import '../view/sidebar_drawer.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late Future<String> _endpointFuture;
  late TextEditingController _controller;
  late TextEditingController _occurrenceDatesController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _occurrenceDatesController = TextEditingController();
    _endpointFuture = _loadEndpoint();
    _loadOccurrenceDates();
  }

  Future<void> _loadOccurrenceDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _occurrenceDatesController.text = prefs.getString('occurrence_dates') ?? '';
    });
  }

  Future<void> _saveOccurrenceDates(String dates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('occurrence_dates', dates);
  }

  // Add this validation function
  bool _isValidDateFormat(String dateStr) {
    final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return datePattern.hasMatch(dateStr.trim());
  }

  String _validateAndCleanDates(String input) {
    if (input.trim().isEmpty) return '';

    // Convert to Set to remove duplicates automatically
    final dates = input.split(',')
        .map((date) => date.trim().replaceAll('"', '').replaceAll("'", ''))
        .where((date) => date.isNotEmpty) // Remove empty entries
        .toSet(); // Convert to Set to remove duplicates

    // Validate each date
    for (var date in dates) {
      if (!_isValidDateFormat(date)) {
        return 'Invalid date format. Use YYYY-MM-DD format separated by commas';
      }
    }

    // Convert back to list, sort in descending order
    final sortedDates = dates.toList()..sort((a, b) => b.compareTo(a));

    // Return cleaned, deduplicated and sorted dates joined by commas
    return sortedDates.join(', ');
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _loadEndpoint() async {
    // Use centralized Config to ensure default matches app-wide default
    return await Config.getEndpoint();
  }

  Future<void> _saveEndpoint(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('endpoint', endpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const SidebarDrawer(),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _endpointFuture,
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Only set the controller once from the loaded value to avoid overwriting user edits on rebuilds
          if (_controller.text.isEmpty) {
            _controller.text = snapshot.data ?? '';
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'API Endpoint',
                          prefixIcon: const Icon(Icons.link),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Label row with icon aligned to text baseline
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.event_note, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Occurrence Dates',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _occurrenceDatesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'YYYY-MM-DD, comma-separated (optional)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 1,
                    ),
                    onPressed: () {
                      String newEndpoint = _controller.text.trim();
                      String datesInput = _occurrenceDatesController.text;

                      String validatedDates = _validateAndCleanDates(datesInput);

                      // If validation failed
                      if (validatedDates.startsWith('Invalid')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(validatedDates)),
                        );
                        return;
                      }

                      // Save both endpoint and cleaned dates (allow empty)
                      _saveEndpoint(newEndpoint);
                      _saveOccurrenceDates(validatedDates);

                      // Update the text field with cleaned and sorted dates
                      setState(() {
                        _occurrenceDatesController.text = validatedDates;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings saved successfully')),
                      );
                    },
                    label: const Text('Save'),
                  ),
                )
              ],
            ),
          );
        },
        ),
      ),
    );
  }
}