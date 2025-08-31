import 'package:fddb_exporter_app/providers/export_provider.dart';
import 'package:fddb_exporter_app/routes/route_generator.dart';
import 'package:fddb_exporter_app/routes/route_names.dart';
import 'package:fddb_exporter_app/service/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExportProvider()),
      ],
      child: MaterialApp(
        title: 'FDDB Exporter',
        theme: () {
          // Build a seed-based ColorScheme and let it derive the primary color.
          final scheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            brightness: Brightness.light,
          ).copyWith(
            // Do not override primary here; we want the derived value from the seed.
            secondary: const Color(0xFF3B82F6),
            outline: const Color(0xFFE5E7EB),
            surface: const Color(0xFFF8FAFC),
            surfaceContainerHighest: const Color(0xFFFFFFFF),
          );

          return ThemeData(
            colorScheme: scheme,
            appBarTheme: AppBarTheme(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              elevation: 0,
            ),
            useMaterial3: true,
          );
        }(),
        initialRoute: RouteNames.home,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

