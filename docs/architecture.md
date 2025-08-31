# Architecture and Design Decisions

This document outlines the core architecture and key design decisions of the FDDB Exporter App.

## Overview

- State management: Provider (ChangeNotifier) per feature (e.g., ExportProvider)
- Services layer: HTTP communication, data parsing, error mapping
- Models: json_serializable-based DTOs with generated .g.dart files
- Routing: Named routes with a central generator (lib/routes)
- DI: Service locator pattern (getIt) for services and error handling
- UI: Material 3 themed widgets; shared components under lib/shared/widgets

## Layers

1. Presentation
   - Widgets in lib/widgets and navigation in lib/view, routes in lib/routes
   - Providers expose state, loading, and AppError values

2. Domain/Services
   - Services in lib/service encapsulate HTTP requests and compose models
   - ErrorService centralizes error transformation and presentation

3. Data/Models
   - Models in lib/models with generated serializers

## Project Structure
- lib/
   - models/: DTOs and generated JSON serializers
   - providers/: Provider-based state management
   - service/: HTTP services, DI, error handling
   - utils/: helpers
   - view/: navigation (e.g., sidebar)
   - widgets/: reusable UI components

## Error Handling

- All exceptions are mapped to AppError subtypes
- User-friendly messages via ErrorService.getUserFriendlyMessage
- UI can show dialogs/snackbars using ErrorService

## Configuration

- API endpoint is stored via SharedPreferences and accessed via Config.getEndpoint
- Default endpoint: http://localhost:8080 (changeable in Settings widget)

## Networking

- http package
- 30s timeout on all calls
- Robust parsing with UTF-8 decode where needed

## Testing

- Unit tests for services, widget tests for critical UI, integration tests for flows
- Mock services provided under test/mocks

## Rationale

- Provider chosen for simplicity and testability
- Service locator simplifies wiring without heavy frameworks
- json_serializable for type-safe, maintainable JSON mapping
