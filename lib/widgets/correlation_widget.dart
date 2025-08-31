import 'package:flutter/material.dart';

import '../models/correlations.dart';
import '../view/sidebar_drawer.dart';
import 'correlation_input_widget.dart';
import 'correlation_result_widget.dart';

class CorrelationWidget extends StatefulWidget {
  final List<String>? initialKeywords;
  final List<String>? initialExclusionKeywords;
  final String? initialStartDate;
  final List<String>? initialOccurrenceDates;

  const CorrelationWidget({
    super.key,
    this.initialKeywords,
    this.initialExclusionKeywords,
    this.initialStartDate,
    this.initialOccurrenceDates
  });


  @override
  _CorrelationWidgetState createState() => _CorrelationWidgetState();
}

class _CorrelationWidgetState extends State<CorrelationWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CorrelationsData? correlationsData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void updateCorrelationsData(CorrelationsData data) {
    setState(() {
      correlationsData = data;
      errorMessage = null;
      _tabController.animateTo(1);
    });
  }

  void handleError(String error) {
    setState(() {
      correlationsData = null;
      errorMessage = error;
      _tabController.animateTo(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async {
        // navigate back to the Input tab instead of popping the route
        if (_tabController.index == 1) {
          _tabController.animateTo(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Correlation'),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: colorScheme.surface,
            labelColor: colorScheme.surface,
            unselectedLabelColor: colorScheme.surface.withOpacity(0.7),
            tabs: const [Tab(text: 'Input'), Tab(text: 'Results')],
          ),
        ),
        drawer: const SidebarDrawer(),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              CorrelationInputTab(
                onSearch: updateCorrelationsData,
                onError: handleError,
              ),
              if (errorMessage != null)
                Center(child: Text('Error: $errorMessage'))
              else if (correlationsData == null)
                const Center(child: Text('No results yet. Please perform a search.'))
              else if (correlationsData!.amountMatchedProducts == 0)
                const Center(child: Text('No matching products found for the given criteria.'))
              else
                CorrelationResultTab(correlationsData: correlationsData!),
            ],
          ),
        ),
      ),
    );
  }
}
