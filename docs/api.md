# API Endpoints and Data Models

This document describes the FDDB Exporter App HTTP API endpoints used by the application and the associated data models.

The base URL (endpoint) is configurable via the app Settings. The default is:
- http://localhost:8080

All requests have a 30s timeout and use structured error handling via AppError types.

## Endpoints

### 1. Export Data

- GET {BASE_URL}/api/v2/fddbdata/export
  - Query parameters:
    - days: integer, number of days to include (required)
    - includeToday: boolean, whether to include today (required)
  - Success: 200 OK with JSON map containing exported data
  - Errors: 4xx ClientError, 5xx ServerError, TimeoutError, NetworkError, ParseError
  - Used by: ExportService.fetchDataFromFirstEndpoint

- POST {BASE_URL}/api/v2/fddbdata
  - Body (JSON): { "fromDate": "yyyy-MM-dd", "toDate": "yyyy-MM-dd" }
  - Success: 200 OK with JSON map containing exported data
  - Errors: same as above
  - Used by: ExportService.fetchDataFromSecondEndpoint

### 2. Daily Nutrition

- GET {BASE_URL}/api/v2/fddbdata/{date}
  - Path parameter: date in format yyyy-MM-dd
  - Success: 200 OK with DailyResult JSON
  - Used by: DailySearchService.fetchDailyNutrition

### 3. Product Search

- GET {BASE_URL}/api/v2/fddbdata/products
  - Query parameters:
    - name: string, search query (required)
  - Success: 200 OK with JSON array of ProductSearchResult
  - Used by: ProductService.fetchProducts

### 4. Statistics

- GET {BASE_URL}/api/v2/stats
  - Success: 200 OK with Stats JSON
  - Used by: StatsService.getStats

- GET {BASE_URL}/api/v2/stats/averages
  - Query parameters:
    - fromDate: string (yyyy-MM-dd), date range start (required)
    - toDate: string (yyyy-MM-dd), date range end (required)
  - Success: 200 OK with StatsAverage JSON
  - Errors: 4xx ClientError, 5xx ServerError, TimeoutError, NetworkError, ParseError
  - Used by: StatsService.getAverages

### 5. Correlation

- POST {BASE_URL}/api/v2/correlation
  - Body (JSON):
    - inclusionKeywords: string[]
    - exclusionKeywords: string[]
    - startDate: string (yyyy-MM-dd), optional/empty allowed
    - occurrenceDates: string[] of yyyy-MM-dd; empty array allowed
  - Success: 200 OK with CorrelationsData JSON
  - Used by: CorrelationService.fetchCorrelationData

## Data Models (Selected)

The app uses json_serializable for JSON mapping; see the corresponding .g.dart files.

- DailyResult (lib/models/daily_result.dart)
  - Represents nutrition totals and entries for a given date

- ProductSearchResult (lib/models/product_search_result.dart)
  - Represents a lightweight product summary result for search

- Product (lib/models/product.dart)
  - Represents a full product entity

- Stats (lib/models/stats.dart)
  - Aggregated counters/statistics for exports and data

- StatsAverage (lib/models/stats_average.dart)
  - Contains average statistics for a date range (fromDate, toDate, averages)

- CorrelationsData (lib/models/correlations.dart)
  - Contains correlation results for provided keywords and dates

- ExportStatus (lib/models/export_status.dart)
  - Represents the export operation status

- AppError and Subtypes (lib/models/app_error.dart)
  - Base error types used through the app: NetworkError, TimeoutError, ServerError, ClientError, ParseError, ValidationError

## Error Handling Contract

- Non-2xx responses are mapped to ClientError (4xx) or ServerError (5xx).
- Network connectivity issues -> NetworkError.
- Requests exceeding 30s -> TimeoutError.
- JSON decoding failures -> ParseError.

Each error can be transformed to a user-facing message via ErrorService.getUserFriendlyMessage and displayed with ErrorService.showErrorDialog/SnackBar.
