import 'package:fddb_exporter_app/models/correlations.dart';
import 'package:fddb_exporter_app/models/daily_result.dart';
import 'package:fddb_exporter_app/models/product_search_result.dart';
import 'package:fddb_exporter_app/models/product.dart';
import 'package:fddb_exporter_app/models/stats.dart';
import 'package:fddb_exporter_app/models/stats_average.dart';
import 'package:fddb_exporter_app/service/interfaces/i_correlation_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_daily_search_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_error_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_export_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_product_service.dart';
import 'package:fddb_exporter_app/service/interfaces/i_stats_service.dart';
import 'package:fddb_exporter_app/models/app_error.dart';
import 'package:flutter/material.dart';

class MockErrorService implements IErrorService {
  @override
  Stream<AppError> get onError => const Stream<AppError>.empty();

  @override
  AppError handleError(dynamic error, [StackTrace? stackTrace]) => AppError(message: error.toString(), stackTrace: stackTrace);

  @override
  String getUserFriendlyMessage(AppError error) => error.toString();

  @override
  Future<void> showErrorDialog(BuildContext context, AppError error) async {}

  @override
  void showErrorSnackBar(BuildContext context, AppError error) {}

  @override
  void dispose() {}
}

class MockExportService implements IExportService {
  @override
  Future<Map<String, dynamic>> fetchDataFromFirstEndpoint(int days, bool includeToday) async => {
        'successfulDays': ['2025-08-15'],
        'unsuccessfulDays': []
      };
  @override
  Future<Map<String, dynamic>> fetchDataFromSecondEndpoint(String fromDate, String toDate) async => {
        'successfulDays': ['2025-08-15'],
        'unsuccessfulDays': []
      };
}

class MockProductService implements IProductService {
  @override
  Future<List<ProductSearchResult>> fetchProducts(String name) async => [
        ProductSearchResult(
          date: DateTime(2025, 8, 15),
          product: Product(
            name: 'Banana',
            amount: '100g',
            calories: 89.0,
            fat: 0.3,
            carbs: 23.0,
            protein: 1.1,
            link: 'https://example.com/banana',
          ),
        )
      ];
}

class MockDailySearchService implements IDailySearchService {
  @override
  Future<DailyResult> fetchDailyNutrition(DateTime date) async => DailyResult(
        date: date,
        products: [
          Product(
            name: 'Banana',
            amount: '100g',
            calories: 89.0,
            fat: 0.3,
            carbs: 23.0,
            protein: 1.1,
            link: 'https://example.com/banana',
          )
        ],
        totalCalories: 89.0,
        totalFat: 0.3,
        totalCarbs: 23.0,
        totalSugar: 12.0,
        totalProtein: 1.1,
        totalFibre: 2.6,
      );
}

class MockStatsService implements IStatsService {
  @override
  Future<Stats> getStats() async => Stats(
        amountEntries: 1,
        firstEntryDate: DateTime(2025, 1, 1),
        mostRecentMissingDay: DateTime(2025, 1, 15),
        entryPercentage: 100.0,
        uniqueProducts: 150,
        averageTotals: Averages(
          avgTotalCalories: 2000.0,
          avgTotalFat: 70.0,
          avgTotalCarbs: 250.0,
          avgTotalSugar: 50.0,
          avgTotalProtein: 90.0,
          avgTotalFibre: 25.0,
        ),
        highestCaloriesDay: DayStats(date: DateTime(2025, 8, 10), total: 3000.0),
        highestFatDay: DayStats(date: DateTime(2025, 8, 11), total: 120.0),
        highestCarbsDay: DayStats(date: DateTime(2025, 8, 12), total: 400.0),
        highestProteinDay: DayStats(date: DateTime(2025, 8, 13), total: 150.0),
        highestFibreDay: DayStats(date: DateTime(2025, 8, 14), total: 35.0),
        highestSugarDay: DayStats(date: DateTime(2025, 8, 15), total: 80.0),
      );

  @override
  Future<StatsAverage> getAverages(String fromDate, String toDate) async => StatsAverage(
        fromDate: fromDate,
        toDate: toDate,
        averages: Averages(
          avgTotalCalories: 2000.0,
          avgTotalFat: 70.0,
          avgTotalCarbs: 250.0,
          avgTotalSugar: 50.0,
          avgTotalProtein: 90.0,
          avgTotalFibre: 25.0,
        ),
      );
}

class MockCorrelationService implements ICorrelationService {
  @override
  Future<CorrelationsData> fetchCorrelationData({
    required List<String> inclusionKeywords,
    required List<String> exclusionKeywords,
    required String startDate,
    required List<String> occurrenceDates,
  }) async => CorrelationsData(
        correlations: Correlations(
          across3Days: CorrelationDetail(percentage: 10, matchedDates: const [], matchedDays: 0),
          across2Days: CorrelationDetail(percentage: 20, matchedDates: const [], matchedDays: 0),
          sameDay: CorrelationDetail(percentage: 30, matchedDates: const [], matchedDays: 0),
          oneDayBefore: CorrelationDetail(percentage: 40, matchedDates: const [], matchedDays: 0),
          twoDaysBefore: CorrelationDetail(percentage: 50, matchedDates: const [], matchedDays: 0),
        ),
        matchedProducts: const ['Banana'],
        matchedDates: const ['2025-08-15'],
        amountMatchedProducts: 1,
        amountMatchedDates: 1,
      );
}
