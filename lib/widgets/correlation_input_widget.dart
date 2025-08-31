import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_error.dart';
import '../models/correlations.dart';
import '../service/correlation_service.dart';
import '../service/error_service.dart';
import '../service/service_locator.dart';

class CorrelationInputTab extends StatefulWidget {
  final Function(CorrelationsData) onSearch;
  final Function(String) onError;

  const CorrelationInputTab({
    super.key,
    required this.onSearch,
    required this.onError,
  });

  @override
  _CorrelationInputTabState createState() => _CorrelationInputTabState();
}

class _CorrelationInputTabState extends State<CorrelationInputTab> {
  final List<String> inclusionKeywords = [];
  final List<String> exclusionKeywords = [];
  final TextEditingController _includeController = TextEditingController();
  final TextEditingController _excludeController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _occurrenceDatesController =
      TextEditingController();
  static const String _occurrenceDatesKey = 'occurrence_dates';
  static const String _inclusionKeywordsKey = 'inclusion_keywords';
  static const String _exclusionKeywordsKey = 'exclusion_keywords';
  static const String _startDateKey = 'start_date';
  final CorrelationService _correlationService = ServiceLocator().correlationService;
  final ErrorService _errorService = ServiceLocator().errorService;
  bool _isLoading = false;
  AppError? _error;
  
  @override
  void initState() {
    super.initState();
    _loadAllPreferences();

    // Add listeners for all controllers
    _occurrenceDatesController.addListener(_saveOccurrenceDates);
    _dateController.addListener(_saveStartDate);
  }

  @override
  void dispose() {
    _occurrenceDatesController.removeListener(_saveOccurrenceDates);
    _occurrenceDatesController.dispose();
    super.dispose();
  }

  Future<void> _loadAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load occurrence dates (existing)
      _occurrenceDatesController.text = prefs.getString('occurrence_dates') ?? '';


      // Load inclusion keywords
      inclusionKeywords.clear();
      inclusionKeywords
          .addAll(prefs.getStringList(_inclusionKeywordsKey) ?? []);

      // Load exclusion keywords
      exclusionKeywords.clear();
      exclusionKeywords
          .addAll(prefs.getStringList(_exclusionKeywordsKey) ?? []);

      // Load start date
      String? savedDate = prefs.getString(_startDateKey);
      if (savedDate != null) {
        _dateController.text = savedDate;
        _selectedDate = DateFormat('yyyy-MM-dd').parse(savedDate);
      }
    });
  }

  Future<void> _saveInclusionKeywords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_inclusionKeywordsKey, inclusionKeywords);
  }

  Future<void> _saveExclusionKeywords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_exclusionKeywordsKey, exclusionKeywords);
  }

  Future<void> _saveStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_startDateKey, _dateController.text);
  }

  Future<void> _saveOccurrenceDates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_occurrenceDatesKey, _occurrenceDatesController.text);
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
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _addInclusionKeyword() {
    if (_includeController.text.isNotEmpty) {
      setState(() {
        inclusionKeywords.add(_includeController.text);
        _includeController.clear();
        _saveInclusionKeywords();
      });
    }
  }

  void _addExclusionKeyword() {
    if (_excludeController.text.isNotEmpty) {
      setState(() {
        exclusionKeywords.add(_excludeController.text);
        _excludeController.clear();
        _saveExclusionKeywords();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: colorScheme.surface,
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Included Keywords',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _includeController,
                      textInputAction: TextInputAction.none,
                      decoration: InputDecoration(
                        hintText: 'Add keywords to include',
                        prefixIcon: const Icon(Icons.add_circle_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addInclusionKeyword(),
                        ),
                      ),
                      onSubmitted: (_) => _addInclusionKeyword(),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: inclusionKeywords
                          .map((word) => Chip(
                              label: Text(word),
                              backgroundColor: colorScheme.secondaryContainer,
                              onDeleted: () => setState(() {
                                    inclusionKeywords.remove(word);
                                    _saveInclusionKeywords(); // Save after removing
                                  })))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Card(
              color: colorScheme.surface,
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Excluded Keywords',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _excludeController,
                      textInputAction: TextInputAction.none,
                      decoration: InputDecoration(
                        hintText: 'Add keywords to exclude',
                        prefixIcon: const Icon(Icons.remove_circle_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addExclusionKeyword(),
                        ),
                      ),
                      onSubmitted: (_) => _addExclusionKeyword(),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: exclusionKeywords
                          .map((word) => Chip(
                              label: Text(word),
                              backgroundColor: colorScheme.errorContainer,
                              onDeleted: () => setState(() {
                                    exclusionKeywords.remove(word);
                                    _saveExclusionKeywords(); // Save after removing
                                  })))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Card(
              color: colorScheme.surface,
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Correlation After',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _showDatePicker,
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(_errorService.getUserFriendlyMessage(_error!), style: const TextStyle(color: Colors.red)),
                ),
              ElevatedButton.icon(
                icon: const Icon(Icons.search),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 1,
                ),
                onPressed: () async {
                  // Validate inclusion keywords
                  if (inclusionKeywords.isEmpty) {
                    setState(() {
                      _error = ValidationError(message: 'At least one inclusion keyword is required');
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_errorService.getUserFriendlyMessage(_error!)), backgroundColor: Colors.redAccent),
                    );
                    return;
                  }

                  // Validate occurrence dates presence from Settings
                  final prefs = await SharedPreferences.getInstance();
                  final savedOccurrenceDates = (prefs.getString(_occurrenceDatesKey) ?? '').trim();
                  if (savedOccurrenceDates.isEmpty) {
                    final appErr = ValidationError(message: 'Occurrence dates are not set. Please set them in Settings > Occurrence Dates.');
                    setState(() { _error = appErr; });
                    // Show error dialog as per guidelines
                    await _errorService.showErrorDialog(context, appErr);
                    widget.onError(_errorService.getUserFriendlyMessage(appErr));
                    return;
                  }

                  try {
                    setState(() { _isLoading = true; _error = null; });

                    // Use occurrence dates from settings to ensure consistency
                    final occurrenceDates = savedOccurrenceDates
                        .split(',')
                        .map((date) => date.trim().replaceAll('"', '').replaceAll("'", ''))
                        .where((d) => d.isNotEmpty)
                        .toList();

                    CorrelationsData results =
                        await _correlationService.fetchCorrelationData(
                          inclusionKeywords: inclusionKeywords,
                          exclusionKeywords: exclusionKeywords,
                          startDate: _selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                              : '',
                          occurrenceDates: occurrenceDates,
                        );
                    if (!mounted) return;
                    setState(() { _isLoading = false; });
                    widget.onSearch(results);
                  } catch (e, stack) {
                    final appError = (e is AppError) ? e : _errorService.handleError(e, stack);
                    if (!mounted) return;
                    setState(() {
                      _error = appError;
                      _isLoading = false;
                    });
                    widget.onError(_errorService.getUserFriendlyMessage(appError));
                  }
                },
                label: const Text('Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
