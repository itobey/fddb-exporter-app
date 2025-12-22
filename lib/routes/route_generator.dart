import 'package:flutter/material.dart';

import '../widgets/correlation_widget.dart';
import '../widgets/daily_search_widget.dart';
import '../widgets/export_data_widget.dart';
import '../widgets/product_search_widget.dart';
import '../widgets/settings_widget.dart';
import '../widgets/stats_widget.dart';
import '../widgets/stats_average_widget.dart';
import 'route_names.dart';

/// Class responsible for generating routes and handling route arguments
class RouteGenerator {
  /// Generate a route based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Get arguments passed to the route
    final args = settings.arguments;

    switch (settings.name) {
      case RouteNames.home:
      case RouteNames.exportData:
        return MaterialPageRoute(
          builder: (_) => const ExportDataWidget(),
        );
        
      case RouteNames.dailySearch:
        // Handle arguments if needed
        if (args is DailySearchArguments) {
          return MaterialPageRoute(
            builder: (_) => DailySearchWidget(
              initialDate: args.initialDate,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const DailySearchWidget(),
        );
        
      case RouteNames.productSearch:
        // Handle arguments if needed
        if (args is ProductSearchArguments) {
          return MaterialPageRoute(
            builder: (_) => ProductSearch(
              initialQuery: args.initialQuery,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const ProductSearch(),
        );
        
      case RouteNames.stats:
        return MaterialPageRoute(
          builder: (_) => const StatsDisplayWidget(),
        );
        
      case RouteNames.statsAverage:
        return MaterialPageRoute(
          builder: (_) => const StatsAverageWidget(),
        );
        
      case RouteNames.correlation:
        // Handle arguments if needed
        if (args is CorrelationArguments) {
          return MaterialPageRoute(
            builder: (_) => CorrelationWidget(
              initialKeywords: args.initialKeywords,
              initialExclusionKeywords: args.initialExclusionKeywords,
              initialStartDate: args.initialStartDate,
              initialOccurrenceDates: args.initialOccurrenceDates,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const CorrelationWidget(),
        );
        
      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => SettingsWidget(),
        );
        
      default:
        // If the route is not found, show an error page
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}

/// Arguments for DailySearchWidget
class DailySearchArguments {
  final DateTime? initialDate;
  
  DailySearchArguments({this.initialDate});
}

/// Arguments for ProductSearch
class ProductSearchArguments {
  final String? initialQuery;
  
  ProductSearchArguments({this.initialQuery});
}

/// Arguments for CorrelationWidget
class CorrelationArguments {
  final List<String>? initialKeywords;
  final List<String>? initialExclusionKeywords;
  final String? initialStartDate;
  final List<String>? initialOccurrenceDates;
  
  CorrelationArguments({
    this.initialKeywords,
    this.initialExclusionKeywords,
    this.initialStartDate,
    this.initialOccurrenceDates,
  });
}