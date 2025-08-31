import 'package:shared_preferences/shared_preferences.dart';

/// the configuration of the app
class Config {
  static Future<String> getEndpoint() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('endpoint') ?? 'http://localhost:8080'; // Default value
    } catch (_) {
      // In tests or environments where SharedPreferences is not available,
      // fall back to the default endpoint to avoid crashes.
      return 'http://localhost:8080';
    }
  }
}