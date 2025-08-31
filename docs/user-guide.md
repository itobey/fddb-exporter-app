# User Guide

This guide explains how to use the FDDB Exporter App’s key features.

## Requirements
- The backend service must be reachable. Default endpoint: http://localhost:8080
- Configure a custom endpoint in Settings if needed.

## Main Features

### 1. Export Data
- Navigate to Export Data screen.
- Choose one of:
  - Days Back: enter number of days and toggle Include today; tap Fetch Data.
  - Timeframe: pick From/To dates; tap Fetch Data.
- Results will display as raw JSON for inspection. Use Clear to reset.

### 2. Daily Nutrition Lookup
- Open Daily Search.
- Select a date; the app fetches daily totals and entries.
- Errors will be shown with descriptive messages.

### 3. Product Search
- Open Product Search.
- Enter a product name and tap Search.
- Results list lightweight product entries; tap to view details if applicable.

### 4. Statistics
- Open Stats.
- App fetches aggregated counters such as total exports.

### 5. Correlation
- Open Correlation.
- Enter Included Keywords (one by one) and optionally Excluded Keywords.
- Select Start Correlation After date (optional).
- Enter Occurrence Dates as comma-separated yyyy-MM-dd values.
- Tap Search. Results show correlation analysis.

### 6. Settings
- Open Settings.
- Configure API Endpoint. This is stored locally and used for all requests.

## Error Messages
- The app displays human-friendly errors (network, timeout, server, client, parsing, validation).
- You can view detailed messages via dialogs or snackbars.

## Tips
- Keep the endpoint updated to match your backend deployment.
- For long queries, be patient; requests timeout after 30 seconds.
- Use Days Back for quick exports; Timeframe for precise control.
